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
@dynamic rank;
@dynamic balance;
@dynamic outstandingBetsValue;
@dynamic user;
@dynamic league;
@dynamic userName;
@dynamic leaderboardRank;

-(BOOL)isAdmin{
    return [self.role integerValue] == 1;
}

-(NSDecimalNumber *)totalWorth{
    return [self.balance decimalNumberByAdding:self.outstandingBetsValue];
}

-(NSDecimalNumber *)maxBet{
    if([self.balance compare:self.league.maxBet] == NSOrderedAscending)
        return self.balance;
    else
        return self.league.maxBet;
}

-(void)prepareForDeletion{
    if(self.user != nil && self.user.remoteId != [User currentUser].remoteId && !self.user.hasBeenDeleted){
        if (self.user != nil) { //WTF? why doesn't the first instance of this catch this?
            [self.managedObjectContext deleteObject:self.user];
        }
    }
}

+(RKEntityMapping *)responseMapping{
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([self class])
                                                   inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    
    [mapping addAttributeMappingsFromArray:@[@"balance", @"role", @"rank"]];
    [mapping addAttributeMappingsFromDictionary:@{
     @"id" : @"remoteId",
     @"outstanding_bets_value" : @"outstandingBetsValue",
     @"league_id" : @"leagueId",
     @"user_id" : @"userId",
     @"user_name" : @"userName",
     @"leaderboard_rank" : @"leaderboardRank",
     @"updated_at" : @"updatedAt",
     @"created_at" : @"createdAt"
     }];
    
    [mapping addConnectionForRelationship:@"user" connectedBy:@{@"userId" : @"remoteId"}];
    [mapping addConnectionForRelationship:@"league" connectedBy:@{@"leagueId" : @"remoteId"}];
    
    return mapping;
}

+(RKEntityMapping *)responseMappingWithLeague{
    RKEntityMapping *mapping = [self responseMapping];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"league"
                                                                            toKeyPath:@"league"
                                                                          withMapping:[League responseMapping]]];
    
    return mapping;
}

+(RKEntityMapping *)responseMappingWithUser{
    RKEntityMapping *mapping = [self responseMapping];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user"
                                                                            toKeyPath:@"user"
                                                                          withMapping:[User responseMapping]]];
    
    return mapping;
}

+(RKMapping *)requestMapping{
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    
    [mapping addAttributeMappingsFromDictionary:@{
     @"remoteId" : @"id"
     }];
    
    return mapping;
}

@end
