//
//  Membership.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/19/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "Membership.h"
#import "League.h"
#import "User.h"


@implementation Membership

@dynamic leagueId;
@dynamic role;
@dynamic rank;
@dynamic balance;
@dynamic outstandingBetsValue;
@dynamic user;
@dynamic league;

-(BOOL)isAdmin{
    return [self.role integerValue] == 1;
}

-(NSDecimalNumber *)totalWorth{
    return [self.balance decimalNumberByAdding:self.outstandingBetsValue];
}

-(NSDecimalNumber *)maxBet{
    if([self.balance compare:self.league.maxBet] == NSOrderedAscending)
        return self.balance;
    else
        return self.league.maxBet;
}

+(RKEntityMapping *)responseMapping{
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([self class])
                                                   inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    
    [mapping addAttributeMappingsFromArray:@[@"balance", @"role", @"rank"]];
    [mapping addAttributeMappingsFromDictionary:@{
     @"id" : @"remoteId",
     @"outstanding_bets_value" : @"outstandingBetsValue",
     @"league_id" : @"leagueId",
     @"user_id" : @"userId",
     @"updated_at" : @"updatedAt",
     @"created_at" : @"createdAt"
     }];
    
    [mapping addConnectionForRelationship:@"user" connectedBy:@{@"userId" : @"remoteId"}];
    [mapping addConnectionForRelationship:@"league" connectedBy:@{@"leagueId" : @"remoteId"}];
    
    return mapping;
}

+(RKEntityMapping *)responseMappingWithParentRelationships{
    RKEntityMapping *mapping = [self responseMapping];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"league"
                                                                            toKeyPath:@"league"
                                                                          withMapping:[League responseMapping]]];
    
    return mapping;
}

+(RKMapping *)requestMapping{
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    
    [mapping addAttributeMappingsFromDictionary:@{
     @"remoteId" : @"id"
     }];
    
    return mapping;
}

@end
