//
//  FFObjectManager.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/11/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <RestKit/RestKit.h>

#import "FFObjectManager.h"
#import "FFRouter.h"
#import "FFApplicationConstants.h"
#import "NSString+Additions.h"
#import "User.h"
#import "Membership.h"
#import "Question.h"
#import "Bet.h"

@implementation FFObjectManager

+(void)setupObjectManager{
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    NSString *path = [RKApplicationDataDirectory() stringByAppendingPathComponent:FFObjectStoreName];
    NSError *error = nil;
    [managedObjectStore addSQLitePersistentStoreAtPath:path fromSeedDatabaseAtPath:nil error:&error];
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
}

-(void)setupResponseDescriptors{
    [self addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[User responseMapping]
                                                                        pathPattern:nil
                                                                            keyPath:@"user"
                                                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [self addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[Membership responseMapping]
                                                                        pathPattern:nil
                                                                            keyPath:@"membership"
                                                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [self addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[Question responseMappingWithChildRelationships]
                                                                        pathPattern:nil
                                                                            keyPath:@"question"
                                                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [self addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[Bet responseMappingWithParentRelationships]
                                                                        pathPattern:nil
                                                                            keyPath:@"bet"
                                                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
}

-(void)setupFetchRequestBlocks{
    [self addFetchRequestBlock:^NSFetchRequest *(NSURL *url){
        RKPathMatcher *pathMatcher = [RKPathMatcher pathMatcherWithPattern:@"/memberships"];
        BOOL match = [pathMatcher matchesPath:[url relativePath] tokenizeQueryStrings:NO parsedArguments:nil];
        
        if (match) {
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Membership"];
            fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:YES]];
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
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"leagueId == %@", leagueId];
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
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"leagueId == %@", leagueId];
            fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:YES]];
            return fetchRequest;
        }
        
        return nil;
    }];
}

@end
