//
//  Question.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/19/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "Question.h"
#import "League.h"
#import "User.h"


@implementation Question

@dynamic questionId;
@dynamic content;
@dynamic desc;
@dynamic approvedAt;
@dynamic createdAt;
@dynamic updatedAt;
@dynamic answers;
@dynamic league;
@dynamic user;
@dynamic approver;

+(RKEntityMapping *)entityMapping{
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([self class])
                                                   inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    
    [mapping addAttributeMappingsFromArray:@[@"content", @"desc"]];
    [mapping addAttributeMappingsFromDictionary:@{
     @"id" : @"questionId",
     @"approved_at" : @"approvedAt",
     @"updated_at" : @"updatedAt",
     @"created_at" : @"createdAt"
     }];
    
    
    return mapping;
}

@end
