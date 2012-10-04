//
//  FFMappingProvider.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/19/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFMappingProvider.h"
#import "User.h"
#import "Membership.h"

@implementation FFMappingProvider

@synthesize  objectStore;

+ (id)mappingProviderWithObjectStore:(RKManagedObjectStore *)objectStore {
    return [[self alloc] initWithObjectStore:objectStore];
}

- (id)initWithObjectStore:(RKManagedObjectStore *)os {
    self = [super init];
    if (self) {
        self.objectStore = os;
        
        [self registerObjectMapping:[self userObjectMapping] withRootKeyPath:@"user"];
        [self setObjectMapping:[self membershipObjectMapping] forResourcePathPattern:@"/memberships" withFetchRequestBlock:^NSFetchRequest *(NSString *resourcePath) {
            NSFetchRequest *fetchRequest = [Membership fetchRequest];
            fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES]];
            return fetchRequest;
        }];
    }
    
    return self;
}

-(RKManagedObjectMapping *)userObjectMapping{
    RKManagedObjectMapping *mapping =  [RKManagedObjectMapping mappingForEntityWithName:@"User"
                                                                   inManagedObjectStore:self.objectStore];
    mapping.rootKeyPath = @"user";
    mapping.primaryKeyAttribute = @"userId";
    [mapping mapAttributes:@"email", @"name", nil];
    [mapping mapKeyPathsToAttributes:
     @"id", @"userId",
     @"authentication_token", @"authenticationToken",
     @"updated_at", @"updatedAt",
     @"created_at", @"createdAt",
     nil];
    
    return mapping;
}

-(RKManagedObjectMapping *)leagueObjectMapping{
    RKManagedObjectMapping *mapping =  [RKManagedObjectMapping mappingForEntityWithName:@"League"
                                                                   inManagedObjectStore:self.objectStore];
    mapping.primaryKeyAttribute = @"leagueId";
    [mapping mapAttributes:@"name", nil];
    [mapping mapKeyPathsToAttributes:
     @"id", @"leagueId",
     @"initial_balance", @"initialBalance",
     @"max_bet", @"maxBet",
     @"priv", @"isPrivate",
     @"updated_at", @"updatedAt",
     @"created_at", @"createdAt",
     nil];
    
    return mapping;
}

-(RKManagedObjectMapping *)questionObjectMapping{
    RKManagedObjectMapping *mapping =  [RKManagedObjectMapping mappingForEntityWithName:@"Question"
                                                                   inManagedObjectStore:self.objectStore];
    mapping.primaryKeyAttribute = @"questionId";
    [mapping mapAttributes:@"content", @"desc", nil];
    [mapping mapKeyPathsToAttributes:
     @"id", @"questionId",
     @"approved_at", @"approvedAt",
     @"updated_at", @"updatedAt",
     @"created_at", @"createdAt",
     nil];
    
    return mapping;
}

-(RKManagedObjectMapping *)answerObjectMapping{
    RKManagedObjectMapping *mapping =  [RKManagedObjectMapping mappingForEntityWithName:@"Answer"
                                                                   inManagedObjectStore:self.objectStore];
    mapping.primaryKeyAttribute = @"answerId";
    [mapping mapAttributes:@"content",  nil];
    [mapping mapKeyPathsToAttributes:
     @"id", @"answerId",
     @"bet_total", @"betTotal",
     @"current_probability", @"currentProbability",
     @"initial_probability", @"initialProbability",
     @"correct", @"isCorrect",
     @"judged_at", @"judgedAt",
     @"updated_at", @"updatedAt",
     @"created_at", @"createdAt",
     nil];
    
    return mapping;
}

-(RKManagedObjectMapping *)betObjectMapping{
    RKManagedObjectMapping *mapping =  [RKManagedObjectMapping mappingForEntityWithName:@"Bet"
                                                                   inManagedObjectStore:self.objectStore];
    mapping.primaryKeyAttribute = @"betId";
    [mapping mapAttributes:@"amount", @"bonus", @"probability", nil];
    [mapping mapKeyPathsToAttributes:
     @"id", @"answerId",
     @"updated_at", @"updatedAt",
     @"created_at", @"createdAt",
     nil];
    
    return mapping;
}

-(RKManagedObjectMapping *)membershipObjectMapping{
    RKManagedObjectMapping *mapping =  [RKManagedObjectMapping mappingForEntityWithName:@"Membership"
                                                                   inManagedObjectStore:self.objectStore];
    
    mapping.rootKeyPath = @"membership";
    mapping.primaryKeyAttribute = @"membershipId";
    [mapping mapAttributes:@"balance", @"role", nil];
    [mapping mapKeyPathsToAttributes:
     @"id", @"membershipId",
     @"updated_at", @"updatedAt",
     @"created_at", @"createdAt",
     nil];
    
    [mapping mapKeyPath:@"league" toRelationship:@"league" withMapping:[self leagueObjectMapping]];
    
    return mapping;
}

@end
