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
@dynamic balance;
@dynamic outstandingBetsValue;
@dynamic user;
@dynamic league;

+(RKEntityMapping *)responseMapping{
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([self class])
                                                   inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    
    [mapping addAttributeMappingsFromArray:@[@"balance", @"role"]];
    [mapping addAttributeMappingsFromDictionary:@{
     @"id" : @"remoteId",
     @"outstanding_bets_value" : @"outstandingBetsValue",
     @"league_id" : @"leagueId",
     @"updated_at" : @"updatedAt",
     @"created_at" : @"createdAt"
     }];
    
    return mapping;
}

+(RKEntityMapping *)responseMappingWithParentRelationships{
    RKEntityMapping *mapping = [self responseMapping];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"league"
                                                                            toKeyPath:@"league"
                                                                          withMapping:[League responseMapping]]];
    
    return mapping;
}

@end
