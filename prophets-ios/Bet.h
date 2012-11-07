//
//  Bet.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/19/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "Resource.h"

@class Answer, User;

@interface Bet : Resource

@property (nonatomic, strong) NSNumber * leagueId;
@property (nonatomic, strong) NSNumber * answerId;
@property (nonatomic, strong) NSDecimalNumber * amount;
@property (nonatomic, strong) NSDecimalNumber * probability;
@property (nonatomic, strong) NSDecimalNumber * bonus;
@property (nonatomic, strong) NSDecimalNumber * payout;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Answer *answer;

-(NSNumber *)dynamicAnswerId;
-(BOOL)hasBeenJudged;
-(NSString *)oddsString;
-(NSDecimalNumber *)potentialPayout;

@end
