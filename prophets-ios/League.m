//
//  League.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/19/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "League.h"
#import "User.h"


@implementation League

@dynamic name;
@dynamic priv;
@dynamic maxBet;
@dynamic initialBalance;
@dynamic membershipsCount;
@dynamic user;
@dynamic memberships;
@dynamic questions;

-(BOOL)isPrivate{
    return self.priv.boolValue;
}

-(void)setIsPrivate:(BOOL)isPrivate{
    self.priv = [NSNumber numberWithBool:isPrivate];
}

+(RKEntityMapping *)responseMapping{
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([self class])
                                                   inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    
    [mapping addAttributeMappingsFromArray:@[@"name"]];
    [mapping addAttributeMappingsFromDictionary:@{
         @"id" : @"remoteId",
         @"initial_balance" : @"initialBalance",
         @"max_bet" : @"maxBet",
         @"memberships_count" : @"membershipsCount",
         @"questions_count" : @"questionsCount",
         @"priv" : @"isPrivate",
         @"updated_at" : @"updatedAt",
         @"created_at" : @"createdAt"
     }];
    
    return mapping;
}

@end
