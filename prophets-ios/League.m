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
@dynamic creatorName;
@dynamic memberships;
@dynamic questions;
@dynamic tags;

@synthesize tagList = _tagList;

-(BOOL)isPrivate{
    return self.priv.boolValue;
}

-(void)setIsPrivate:(BOOL)isPrivate{
    self.priv = [NSNumber numberWithBool:isPrivate];
}

-(NSString *)tagList{
    if(_tagList) return _tagList;
    
    NSMutableString *str = [NSMutableString string];
    NSArray *tags = [self.tags allObjects];
    for (int i=0; i<tags.count; i++) {
        Tag *tag = [tags objectAtIndex:i];
        if (i == self.tags.count - 1) {
            [str appendString:tag.name];
        }
        else{
            [str appendFormat:@"%@, ", tag.name];
        }
    }
    
    return str;
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
         @"creator_name" : @"creatorName",
         @"updated_at" : @"updatedAt",
         @"created_at" : @"createdAt"
     }];
    
    [mapping addRelationshipMappingWithSourceKeyPath:@"tags" mapping:[Tag responseMapping]];
    
    return mapping;
}

+(RKMapping *)requestMapping{
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    
    [mapping addAttributeMappingsFromArray:@[@"name", @"priv", @"password"]];
    [mapping addAttributeMappingsFromDictionary:@{
     @"remoteId" : @"id",
     @"tagList" : @"tag_list"
     }];
    return mapping;
}

@end
