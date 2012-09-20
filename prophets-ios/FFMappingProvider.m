//
//  FFMappingProvider.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/19/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFMappingProvider.h"

@implementation FFMappingProvider

@synthesize  objectStore;

+ (id)mappingProviderWithObjectStore:(RKManagedObjectStore *)objectStore {
    return [[self alloc] initWithObjectStore:objectStore];
}

- (id)initWithObjectStore:(RKManagedObjectStore *)os {
    self = [super init];
    if (self) {
        self.objectStore = os;
    }
    
    return self;
}

-(RKManagedObjectMapping *)userObjectMapping{
    RKManagedObjectMapping *mapping =  [RKManagedObjectMapping mappingForEntityWithName:@"User"
                                                                   inManagedObjectStore:self.objectStore];
    mapping.primaryKeyAttribute = @"userId";
    [mapping mapAttributes:@"email", @"name", nil];
    [mapping mapKeyPathsToAttributes:
     @"id", @"userId",
     @"updated_at", @"updatedAt",
     @"created_at", @"createdAt",
     nil];
    
    return mapping;
}

-(RKManagedObjectMapping *)leagueObjectMapping{
    RKManagedObjectMapping *mapping =  [RKManagedObjectMapping mappingForEntityWithName:@"League"
                                                                   inManagedObjectStore:self.objectStore];
    mapping.primaryKeyAttribute = @"leagueId";
    [mapping mapAttributes:@"name", @"priv", nil];
    [mapping mapKeyPathsToAttributes:
     @"id", @"leagueId",
     @"initialBalance", @"initialBalance",
     @"max_bet", @"maxBet",
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
    [mapping mapAttributes:@"content", @"correct", nil];
    [mapping mapKeyPathsToAttributes:
     @"id", @"answerId",
     @"bet_total", @"betTotal",
     @"current_probability", @"currentProbability",
     @"initial_probability", @"initialProbability",
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
    mapping.primaryKeyAttribute = @"membershipId";
    [mapping mapAttributes:@"balance", @"role", nil];
    [mapping mapKeyPathsToAttributes:
     @"id", @"membershipId",
     @"updated_at", @"updatedAt",
     @"created_at", @"createdAt",
     nil];
    
    return mapping;
}

@end
