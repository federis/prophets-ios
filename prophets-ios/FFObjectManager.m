//
//  FFObjectManager.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/11/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RKErrorMessage.h>

#import "FFObjectManager.h"
#import "FFRouter.h"
#import "FFApplicationConstants.h"
#import "NSString+Additions.h"
#import "User.h"
#import "Membership.h"
#import "Question.h"
#import "Bet.h"
#import "Comment.h"
#import "Answer.h"
#import "League.h"
#import "Tag.h"
#import "Activity.h"
#import "ErrorCollection.h"
#import "NSURL+Additions.h"
#import "FFManagedObjectRequestOperation.h"

@implementation FFObjectManager

+(void)setupObjectManager{
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    NSString *path = [RKApplicationDataDirectory() stringByAppendingPathComponent:FFObjectStoreName];
    NSError *error = nil;
    [managedObjectStore addSQLitePersistentStoreAtPath:path fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
    [managedObjectStore createManagedObjectContexts];
    
    FFObjectManager* objectManager = [FFObjectManager managerWithBaseURL:[NSURL URLWithString:FFBaseUrl]];
    objectManager.managedObjectStore = managedObjectStore;
    
    FFRouter *router = [[FFRouter alloc] initWithBaseURL:objectManager.baseURL];
    objectManager.router = router;
    
    [objectManager setupRequestDescriptors];
    [objectManager setupResponseDescriptors];
    [objectManager setupFetchRequestBlocks];
    
    [objectManager registerRequestOperationClass:[FFManagedObjectRequestOperation class]];
}

-(void)setupRequestDescriptors{
    [self addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:[User requestMapping]
                                                                     objectClass:[User class]
                                                                     rootKeyPath:@"user"]];
    
    [self addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:[League requestMapping]
                                                                     objectClass:[League class]
                                                                     rootKeyPath:@"league"]];
    
    [self addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:[Bet requestMapping]
                                                                     objectClass:[Bet class]
                                                                     rootKeyPath:@"bet"]];
    
    [self addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:[Comment requestMapping]
                                                                     objectClass:[Comment class]
                                                                     rootKeyPath:@"comment"]];
    
    [self addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:[Question requestMapping]
                                                                     objectClass:[Question class]
                                                                     rootKeyPath:@"question"]];
    
    [self addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:[Answer requestMapping]
                                                                     objectClass:[Answer class]
                                                                     rootKeyPath:@"answer"]];
    
    [self addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:[Membership requestMapping]
                                                                     objectClass:[Membership class]
                                                                     rootKeyPath:@"membership"]];
    
}

-(void)setupResponseDescriptors{
    
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[ErrorCollection class]];
    [errorMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"errors" toKeyPath:@"messages"]];

    [self addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:errorMapping pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError)]];

    
    [self addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[User responseMapping]
                                                                        pathPattern:nil
                                                                            keyPath:@"user"
                                                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [self addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[Membership responseMappingWithLeague]
                                                                        pathPattern:@"/memberships"
                                                                            keyPath:@"membership"
                                                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [self addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[Membership responseMapping]
                                                                        pathPattern:@"/leagues/:remoteId/leaderboard"
                                                                            keyPath:@"membership"
                                                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [self addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[Membership responseMappingWithUser]
                                                                        pathPattern:@"/leagues/:remoteId/memberships"
                                                                            keyPath:@"membership"
                                                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [self addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[Question responseMappingWithAnswers]
                                                                        pathPattern:nil
                                                                            keyPath:@"question"
                                                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    // get list of user's bets in the league
    [self addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[Bet responseMappingWithAnswer]
                                                                        pathPattern:@"/leagues/:remoteId/bets"
                                                                            keyPath:@"bet"
                                                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [self addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[Bet responseMappingWithAnswer]
                                                                        pathPattern:@"/bets/:remoteId"
                                                                            keyPath:@"bet"
                                                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    // creating bets
    [self addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[Bet responseMappingWithMembership]
                                                                        pathPattern:@"/answers/:answerId/bets"
                                                                            keyPath:@"bet"
                                                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    
    [self addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[Comment responseMapping]
                                                                        pathPattern:nil
                                                                            keyPath:@"comment"
                                                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    
    [self addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[League responseMapping]
                                                                        pathPattern:nil
                                                                            keyPath:@"league"
                                                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    
    [self addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[Answer responseMapping]
                                                                        pathPattern:nil
                                                                            keyPath:@"answer"
                                                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [self addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[Tag responseMapping]
                                                                        pathPattern:nil
                                                                            keyPath:@"tag"
                                                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [self addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[Activity responseMapping]
                                                                        pathPattern:nil
                                                                            keyPath:@"activity"
                                                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
}

-(void)setupFetchRequestBlocks{
    [self addFetchRequestBlock:^NSFetchRequest *(NSURL *url){
        RKPathMatcher *pathMatcher = [RKPathMatcher pathMatcherWithPattern:@"/memberships"];
        BOOL match = [pathMatcher matchesPath:[url relativePath] tokenizeQueryStrings:NO parsedArguments:nil];
        
        if (match) {
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Membership"];
            User *user = [User currentUser];
            NSNumber *userId = user.remoteId;
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"userId == %@", userId];
            fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO]];
            fetchRequest.relationshipKeyPathsForPrefetching = @[@"league"];
            return fetchRequest;
        }
        
        return nil;
    }];
    
    [self addFetchRequestBlock:^NSFetchRequest *(NSURL *url){
        RKPathMatcher *pathMatcher = [RKPathMatcher pathMatcherWithPattern:@"/leagues/:leagueId/leaderboard"];
        
        NSDictionary *argsDict = nil;
        BOOL match = [pathMatcher matchesPath:[url relativePath] tokenizeQueryStrings:NO parsedArguments:&argsDict];
        if (match) {
            NSNumber *leagueId = [(NSString *)[argsDict objectForKey:@"leagueId"] numberValue];
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Membership"];
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"leagueId == %@ AND userName != nil", leagueId];
            fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"leaderboardRank" ascending:YES]];
            
            return fetchRequest;
        }
        
        return nil;
    }];
    
    [self addFetchRequestBlock:^NSFetchRequest *(NSURL *url){
        RKPathMatcher *pathMatcher = [RKPathMatcher pathMatcherWithPattern:@"/leagues/:leagueId/memberships"];
        
        NSDictionary *argsDict = nil;
        BOOL match = [pathMatcher matchesPath:[url relativePath] tokenizeQueryStrings:NO parsedArguments:&argsDict];
        if (match) {
            NSNumber *leagueId = [(NSString *)[argsDict objectForKey:@"leagueId"] numberValue];
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Membership"];
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"leagueId == %@", leagueId];
            fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"user.email" ascending:YES]];
            
            return fetchRequest;
        }
        
        return nil;
    }];
    
    [self addFetchRequestBlock:^NSFetchRequest *(NSURL *url){
        RKPathMatcher *pathMatcher = [RKPathMatcher pathMatcherWithPattern:@"/leagues/:leagueId/questions"];
        
        NSDictionary *argsDict = nil;
        BOOL match = [pathMatcher matchesPath:[url relativePath] tokenizeQueryStrings:NO parsedArguments:&argsDict];
        if (match) {
            NSNumber *leagueId = [(NSString *)[argsDict objectForKey:@"leagueId"] numberValue];
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Question"];
            
            NSString *type = [[url queryDictionary] objectForKey:@"type"];
            if ([type isEqualToString:@"unapproved"]) {
                fetchRequest.predicate = [NSPredicate predicateWithFormat:@"leagueId == %@ AND approvedAt == NULL", leagueId];
            }
            else if ([type isEqualToString:@"pending_judgement"]){
                fetchRequest.predicate = [NSPredicate predicateWithFormat:@"leagueId == %@ AND approvedAt != NULL AND completedAt == NULL AND bettingClosesAt < %@", leagueId, [NSDate date]];
            }
            else if ([type isEqualToString:@"complete"]){
                fetchRequest.predicate = [NSPredicate predicateWithFormat:@"leagueId == %@ AND completedAt != NULL", leagueId];
            }
            else{
                fetchRequest.predicate = [NSPredicate predicateWithFormat:@"leagueId == %@ AND approvedAt != NULL AND completedAt == NULL AND bettingClosesAt > %@", leagueId, [NSDate date]];
            }
            
            fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO]];
            return fetchRequest;
        }
        
        return nil;
    }];
    
    [self addFetchRequestBlock:^NSFetchRequest *(NSURL *url){
        RKPathMatcher *pathMatcher = [RKPathMatcher pathMatcherWithPattern:@"/leagues/:leagueId/bets"];
        
        NSDictionary *argsDict = nil;
        BOOL match = [pathMatcher matchesPath:[url relativePath] tokenizeQueryStrings:NO parsedArguments:&argsDict];
        if (match) {
            NSNumber *leagueId = [(NSString *)[argsDict objectForKey:@"leagueId"] numberValue];
            Membership *membership = [[User currentUser] membershipInLeague:leagueId];
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Bet"];
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"membershipId == %@", membership.remoteId];
            fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO]];
            return fetchRequest;
        }
        
        return nil;
    }];
    
    
    [self addFetchRequestBlock:^NSFetchRequest *(NSURL *url){
        RKPathMatcher *pathMatcher = [RKPathMatcher pathMatcherWithPattern:@"/leagues/:leagueId/comments"];
        
        NSDictionary *argsDict = nil;
        BOOL match = [pathMatcher matchesPath:[url relativePath] tokenizeQueryStrings:NO parsedArguments:&argsDict];
        if (match) {
            NSNumber *leagueId = [(NSString *)[argsDict objectForKey:@"leagueId"] numberValue];
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Comment"];
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"leagueId == %@", leagueId];
            fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO]];
            return fetchRequest;
        }
        
        return nil;
    }];
    
    
    [self addFetchRequestBlock:^NSFetchRequest *(NSURL *url){
        RKPathMatcher *pathMatcher = [RKPathMatcher pathMatcherWithPattern:@"/questions/:questionId/comments"];
        
        NSDictionary *argsDict = nil;
        BOOL match = [pathMatcher matchesPath:[url relativePath] tokenizeQueryStrings:NO parsedArguments:&argsDict];
        if (match) {
            NSNumber *questionId = [(NSString *)[argsDict objectForKey:@"questionId"] numberValue];
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Comment"];
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"questionId == %@", questionId];
            fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO]];
            return fetchRequest;
        }
        
        return nil;
    }];
    
    
    [self addFetchRequestBlock:^NSFetchRequest *(NSURL *url){
        RKPathMatcher *pathMatcher = [RKPathMatcher pathMatcherWithPattern:@"/bets/:betId/comments"];
        
        NSDictionary *argsDict = nil;
        BOOL match = [pathMatcher matchesPath:[url relativePath] tokenizeQueryStrings:NO parsedArguments:&argsDict];
        if (match) {
            NSNumber *betId = [(NSString *)[argsDict objectForKey:@"betId"] numberValue];
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Comment"];
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"betId == %@", betId];
            fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO]];
            return fetchRequest;
        }
        
        return nil;
    }];
    
    
    [self addFetchRequestBlock:^NSFetchRequest *(NSURL *url){
        RKPathMatcher *pathMatcher = [RKPathMatcher pathMatcherWithPattern:@"/tags"];
        BOOL match = [pathMatcher matchesPath:[url relativePath] tokenizeQueryStrings:NO parsedArguments:nil];
        
        if (match) {
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
            fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO]];
            return fetchRequest;
        }
        
        return nil;
    }];
    
    
    [self addFetchRequestBlock:^NSFetchRequest *(NSURL *url){
        RKPathMatcher *pathMatcher = [RKPathMatcher pathMatcherWithPattern:@"/tags/:tagId/leagues"];
        
        NSDictionary *argsDict = nil;
        BOOL match = [pathMatcher matchesPath:[url relativePath] tokenizeQueryStrings:NO parsedArguments:&argsDict];
        if (match) {
            NSNumber *tagId = [(NSString *)[argsDict objectForKey:@"tagId"] numberValue];
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"League"];
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"ANY tags.remoteId == %@", tagId];
            fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO]];
            return fetchRequest;
        }
        
        return nil;
    }];
    
    
    [self addFetchRequestBlock:^NSFetchRequest *(NSURL *url){
        RKPathMatcher *pathMatcher = [RKPathMatcher pathMatcherWithPattern:@"/leagues/:leagueId/activities"];
        
        NSDictionary *argsDict = nil;
        BOOL match = [pathMatcher matchesPath:[url relativePath] tokenizeQueryStrings:NO parsedArguments:&argsDict];
        if (match) {
            NSNumber *leagueId = [(NSString *)[argsDict objectForKey:@"leagueId"] numberValue];
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Activity"];
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"leagueId == %@", leagueId];
            fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO]];
            return fetchRequest;
        }
        
        return nil;
    }];
}

@end
