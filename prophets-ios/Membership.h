//
//  Membership.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/19/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "Resource.h"

@class League, User;

@interface Membership : Resource

@property (nonatomic, strong) NSNumber * leagueId;
@property (nonatomic, strong) NSNumber * role;
@property (nonatomic, strong) NSNumber * rank;
@property (nonatomic, strong) NSDecimalNumber * balance;
@property (nonatomic, strong) NSDecimalNumber * outstandingBetsValue;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) League *league;
@property (nonatomic, strong) NSDecimalNumber *leaderboardRank;

-(BOOL)isAdmin;
-(NSDecimalNumber *)totalWorth;
-(NSDecimalNumber *)maxBet;

@end
