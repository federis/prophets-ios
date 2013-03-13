//
//  FFDeepLinker.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 3/6/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <SVProgressHUD.h>

#import "FFDeepLinker.h"
#import "League.h"
#import "Question.h"
#import "User.h"
#import "NSManagedObjectContext+Additions.h"

#import "JoinLeagueViewController.h"
#import "MembershipsViewController.h"
#import "LeagueTabBarController.h"
#import "QuestionsViewController.h"
#import "AnswersViewController.h"

static FFDeepLinker *sharedLinker = nil;

@implementation FFDeepLinker

+(instancetype)sharedLinker{
    return sharedLinker;
}

+(void)setSharedLinker:(FFDeepLinker *)linker{
    sharedLinker = linker;
}

+(NSDictionary *)deepLinkPatterns{
    return @{
             @"//leagues/(\\d+)/join" : @"handleJoinLeagueURL:",
             @"//leagues/(\\d+)/questions/(\\d+)" : @"handleShowQuestionURL:"
             };
}

-(void)handleUrl:(NSURL *)url{
    NSString *linkString = [url resourceSpecifier];
    
    NSError *error = NULL;
    for (NSString *pattern in [[FFDeepLinker deepLinkPatterns] allKeys]) {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        NSTextCheckingResult *result = [regex firstMatchInString:linkString options:NSMatchingAnchored range:NSMakeRange(0, linkString.length)];
        if (result) {
            NSMutableArray *captures = [NSMutableArray array];
            for (int i=1; i<result.numberOfRanges; i++) {
                NSRange range = [result rangeAtIndex:i];
                NSString *capture = [linkString substringWithRange:range];
                [captures addObject:capture];
            }
            
            NSString *selector = [[FFDeepLinker deepLinkPatterns] objectForKey:pattern];
            [self performSelector:NSSelectorFromString(selector) withObject:captures];
            return;
        }
    }
}

-(NSManagedObjectContext *)scratchContext{
    if(_scratchContext) return _scratchContext;
    
    _scratchContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    [_scratchContext performBlockAndWait:^{
        _scratchContext.parentContext = self.managedObjectContext;
        _scratchContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;
    }];
    
    return _scratchContext;
}


-(void)handleJoinLeagueURL:(NSArray *)capturedComponents{
    NSInteger leagueId = [(NSString *)[capturedComponents objectAtIndex:0] integerValue];
    
    if (leagueId){
        League *league = [[self.managedObjectContext fetchObjectsForEntityName:@"League" withPredicate:@"remoteId = %i", leagueId] anyObject];
        if(league){
            [self showJoinLeague:league];
        }
        else{
            league = [self.scratchContext insertNewObjectForEntityForName:@"League"];
            league.remoteId = [NSNumber numberWithInteger:leagueId];
            [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeGradient];
            [[RKObjectManager sharedManager] getObject:league path:nil parameters:nil
               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
                   [SVProgressHUD dismiss];
                   DLog(@"Result is %@", mappingResult);
                   League *l = (League *)[self.managedObjectContext objectWithID:[league objectID]];
                   [self showJoinLeague:l];
               }
               failure:^(RKObjectRequestOperation *operation, NSError *error){
                   [SVProgressHUD dismiss];
                   [SVProgressHUD showErrorWithStatus:@"Error loading league"];
                   DLog(@"Error is %@", error);
               }];
        }
    }
}

-(void)showJoinLeague:(League *)league{
    JoinLeagueViewController *joinLeagueVC = [self.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"JoinLeagueViewController"];
    joinLeagueVC.league = league;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:joinLeagueVC];
    [self.rootViewController presentViewController:navController animated:NO completion:^{}];
}


-(void)handleShowQuestionURL:(NSArray *)capturedComponents{
    NSInteger leagueId = [(NSString *)[capturedComponents objectAtIndex:0] integerValue];
    NSInteger questionId = [(NSString *)[capturedComponents objectAtIndex:1] integerValue];
    
    if (!leagueId || !questionId || ![User currentUser]) return;
    
    Question *question = [[self.managedObjectContext fetchObjectsForEntityName:@"Question" withPredicate:@"remoteId = %i", questionId] anyObject];
    
    Membership *membership = [[User currentUser] membershipInLeague:[NSNumber numberWithInteger:leagueId]];
    
    if(question && membership){
        if([question.league.remoteId integerValue] == leagueId){
            [self showQuestion:question withMembership:membership];
        }
    }
    else{
        NSMutableArray *requests = [NSMutableArray array];
        if (!question) {
            question = [self.scratchContext insertNewObjectForEntityForName:@"Question"];
            question.remoteId = [NSNumber numberWithInteger:questionId];
            question.leagueId = [NSNumber numberWithInteger:leagueId];
            RKManagedObjectRequestOperation *request = [[RKObjectManager sharedManager] appropriateObjectRequestOperationWithObject:question method:RKRequestMethodGET path:nil parameters:nil];
            
            [requests addObject:request];
        }
        
        if (!membership) {
            RKObjectRequestOperation *request = [[RKObjectManager sharedManager] appropriateObjectRequestOperationWithObject:[User currentUser] method:RKRequestMethodGET path:@"/memberships" parameters:nil];
            [requests addObject:request];
        }
        
        [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeGradient];
        [[RKObjectManager sharedManager] enqueueBatchOfObjectRequestOperations:requests
          progress:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
              
          } completion:^ (NSArray *operations) {
              
              [SVProgressHUD dismiss];
              
              for (RKManagedObjectRequestOperation *operation in operations) {
                  if (operation.error) {
                      DLog(@"%@", operation.error);
                      
                      [SVProgressHUD showErrorWithStatus:[operation.error description]];
                      return;
                  }
              }
              
              Question *q = (Question *)[self.managedObjectContext objectWithID:question.objectID];
              Membership *m = [[User currentUser] membershipInLeague:[NSNumber numberWithInteger:leagueId]];
              [self showQuestion:q withMembership:m];
          }];
        
    }
    
}

-(void)showQuestion:(Question *)question withMembership:(Membership *)membership{
    MembershipsViewController *membershipsVC = [self.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"MembershipsViewController"];
    
    LeagueTabBarController *leagueVC = [self.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"LeagueTabBarController"];
    leagueVC.membership = membership;
    
    QuestionsViewController *questionsVC = [self.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"QuestionsViewController"];
    questionsVC.membership = membership;
    
    AnswersViewController *answersVC = [self.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"AnswersViewController"];
    answersVC.question = question;
    answersVC.membership = membership;
    
    UINavigationController *navController = [[UINavigationController alloc] init];
    [navController setViewControllers:@[membershipsVC, leagueVC, questionsVC, answersVC] animated:NO];
    
    [self.rootViewController presentViewController:navController animated:NO completion:^{}];
}


@end
