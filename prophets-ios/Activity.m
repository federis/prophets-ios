//
//  Activity.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 4/22/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import "Activity.h"


@implementation Activity

@dynamic content;
@dynamic leagueId;
@dynamic activityType;
@dynamic feedableId;
@dynamic feedableType;
@dynamic commentsCount;

+(RKEntityMapping *)responseMapping{
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([self class])
                                                   inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    
    [mapping addAttributeMappingsFromArray:@[@"content"]];
    [mapping addAttributeMappingsFromDictionary:@{
     @"id" : @"remoteId",
     @"league_id" : @"leagueId",
     @"feedable_id" : @"feedableId",
     @"feedable_type" : @"feedableType",
     @"comments_count" : @"commentsCount",
     @"updated_at" : @"updatedAt",
     @"created_at" : @"createdAt",
     }];
    
    [mapping addConnectionForRelationship:@"league" connectedBy:@{@"leagueId" : @"remoteId"}];
    
    return mapping;
}

@end
