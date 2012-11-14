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
#import "Answer.h"

@implementation Question

@dynamic content;
@dynamic desc;
@dynamic approvedAt;
@dynamic bettingClosesAt;
@dynamic betsCount;
@dynamic commentsCount;
@dynamic answers;
@dynamic leagueId;
@dynamic league;
@dynamic user;
@dynamic approver;

-(NSNumber *)dynamicLeagueId{
    if (self.leagueId)
        return self.leagueId;
    else if(self.league && self.league.remoteId)
        return self.league.remoteId;
    else
        return nil;
}

-(BOOL)isOpenForBetting{
    return self.isApproved && [self.bettingClosesAt compare:[NSDate date]] == NSOrderedDescending;
}

-(BOOL)isApproved{
    return self.approvedAt != nil;
}

+(RKEntityMapping *)responseMapping{
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([self class])
                                                   inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    
    [mapping addAttributeMappingsFromArray:@[@"content", @"desc"]];
    [mapping addAttributeMappingsFromDictionary:@{
     @"id" : @"remoteId",
     @"league_id" : @"leagueId",
     @"approved_at" : @"approvedAt",
     @"betting_closes_at" : @"bettingClosesAt",
     @"bets_count" : @"betsCount",
     @"comments_count" : @"commentsCount",
     @"updated_at" : @"updatedAt",
     @"created_at" : @"createdAt"
     }];
    
    [mapping addConnectionMappingForRelationshipForName:@"league"
                                      fromSourceKeyPath:@"leagueId"
                                              toKeyPath:@"remoteId"
                                                matcher:nil];    
    
    return mapping;
}

+(RKEntityMapping *)responseMappingWithChildRelationships{
    RKEntityMapping *mapping = [self responseMapping];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"answers"
                                                                            toKeyPath:@"answers"
                                                                          withMapping:[Answer responseMapping]]];
    return mapping;
}

+(RKMapping *)requestMapping{
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    
    [mapping addAttributeMappingsFromArray:@[@"content", @"desc"]];
    [mapping addAttributeMappingsFromDictionary:@{
     @"bettingClosesAt" : @"betting_closes_at"
     }];
    return mapping;
}

@end
