//
//  Comment.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/2/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "Comment.h"
#import "League.h"
#import "Question.h"


@implementation Comment

@dynamic comment;
@dynamic userName;
@dynamic leagueId;
@dynamic questionId;
@dynamic userId;
@dynamic league;
@dynamic question;


+(RKEntityMapping *)responseMapping{
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([self class])
                                                   inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    
    [mapping addAttributeMappingsFromArray:@[@"comment"]];
    [mapping addAttributeMappingsFromDictionary:@{
     @"id" : @"remoteId",
     @"league_id" : @"leagueId",
     @"question_id" : @"questionId",
     @"user_id" : @"userId",
     @"user_name" : @"userName",
     @"updated_at" : @"updatedAt",
     @"created_at" : @"createdAt"
     }];
    
    [mapping addConnectionForRelationship:@"league" connectedBy:@{@"leagueId" : @"remoteId"}];
    [mapping addConnectionForRelationship:@"question" connectedBy:@{@"questionId" : @"remoteId"}];
    
    return mapping;
}

+(RKMapping *)requestMapping{
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    [mapping addAttributeMappingsFromArray:@[@"comment"]];
    return mapping;
}

@end
