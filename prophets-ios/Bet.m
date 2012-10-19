//
//  Bet.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/19/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "Bet.h"
#import "Answer.h"
#import "User.h"


@implementation Bet

@dynamic amount;
@dynamic probability;
@dynamic bonus;
@dynamic createdAt;
@dynamic updatedAt;
@dynamic user;
@dynamic answer;

+(RKEntityMapping *)responseMapping{
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([self class])
                                                   inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    
    [mapping addAttributeMappingsFromArray:@[@"amount", @"bonus", @"probability"]];
    [mapping addAttributeMappingsFromDictionary:@{
     @"id" : @"remoteId",
     @"updated_at" : @"updatedAt",
     @"created_at" : @"createdAt",
     }];
    
    return mapping;
}

+(RKEntityMapping *)requestMapping{
    
}

@end
