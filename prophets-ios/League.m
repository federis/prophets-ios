//
//  League.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/19/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "League.h"
#import "User.h"
#import "Tag.h"


@implementation League

@dynamic name;
@dynamic priv;
@dynamic maxBet;
@dynamic initialBalance;
@dynamic membershipsCount;
@dynamic questionsCount;
@dynamic commentsCount;
@dynamic user;
@dynamic memberships;
@dynamic questions;
@dynamic tags;

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
         @"comments_count" : @"commentsCount",
         @"priv" : @"isPrivate",
         @"updated_at" : @"updatedAt",
         @"created_at" : @"createdAt"
     }];
    
    [mapping addRelationshipMappingWithSourceKeyPath:@"tags" mapping:[Tag responseMapping]];
    
    return mapping;
}

+(RKMapping *)requestMapping{
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    
    [mapping addAttributeMappingsFromArray:@[@"name", @"priv"]];
    [mapping addAttributeMappingsFromDictionary:@{
     @"remoteId" : @"id"
     }];
    return mapping;
}

@end
