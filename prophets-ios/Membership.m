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

@dynamic membershipId;
@dynamic role;
@dynamic balance;
@dynamic createdAt;
@dynamic updatedAt;
@dynamic user;
@dynamic league;

+(RKEntityMapping *)entityMapping{
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([self class])
                                                   inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    
    [mapping addAttributeMappingsFromArray:@[@"balance", @"role"]];
    [mapping addAttributeMappingsFromDictionary:@{
     @"id" : @"membershipId",
     @"updated_at" : @"updatedAt",
     @"created_at" : @"createdAt"
     }];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"league"
                                                                            toKeyPath:@"league"
                                                                          withMapping:[League entityMapping]]];
    
    return mapping;
}

@end
