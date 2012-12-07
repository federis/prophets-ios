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
    
}

-(void)setupResponseDescriptors{
    /*
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[RKErrorMessage class]];
    [errorMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"errors" toKeyPath:@"userInfo"]];
    
    [self addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:errorMapping
                                                                        pathPattern:nil
                                                                            keyPath:nil
                                                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError)]];
     */
    
    [self addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[User responseMapping]
                                                                        pathPattern:nil
                                                                            keyPath:@"user"
                                                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [self addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[Membership responseMappingWithParentRelationships]
                                                                        pathPattern:nil
                                                                            keyPath:@"membership"
                                                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [self addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[Question responseMappingWithChildRelationships]
                                                                        pathPattern:nil
                                                                            keyPath:@"question"
                                                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    // get list of user's bets in the league
    [self addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[Bet responseMappingWithParentRelationships]
                                                                        pathPattern:@"/leagues/:remoteId/bets"
                                                                            keyPath:@"bet"
                                                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    // creating bets
    [self addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[Bet responseMappingWithChildRelationships]
                                                                        pathPattern:@"/answers/:dynamicAnswerId/bets"
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
}

-(void)setupFetchRequestBlocks{
    [self addFetchRequestBlock:^NSFetchRequest *(NSURL *url){
        RKPathMatcher *pathMatcher = [RKPathMatcher pathMatcherWithPattern:@"/memberships"];
        BOOL match = [pathMatcher matchesPath:[url relativePath] tokenizeQueryStrings:NO parsedArguments:nil];
        
        if (match) {
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Membership"];
            fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO]];
            fetchRequest.relationshipKeyPathsForPrefetching = @[@"league"];
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
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"leagueId == %@ AND approvedAt != NULL", leagueId];
            fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:YES]];
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
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Bet"];
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"membership.leagueId == %@", leagueId];
            fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:YES]];
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
}

@end
