//
//  Bet.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/19/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "Resource.h"

@class Answer, Membership;

@interface Bet : Resource

@property (nonatomic, strong) NSNumber * membershipId;
@property (nonatomic, strong) NSNumber * answerId;
@property (nonatomic, strong) NSDecimalNumber * amount;
@property (nonatomic, strong) NSDecimalNumber * probability;
@property (nonatomic, strong) NSDecimalNumber * bonus;
@property (nonatomic, strong) NSDecimalNumber * payout;
@property (nonatomic, strong) NSDate * invalidatedAt;
@property (nonatomic, retain) NSNumber * commentsCount;
@property (nonatomic, strong) Membership *membership;
@property (nonatomic, strong) Answer *answer;

-(BOOL)hasBeenJudged;
-(NSString *)oddsString;
-(NSDecimalNumber *)potentialPayout;

+(RKEntityMapping *)responseMappingWithAnswer;
+(RKEntityMapping *)responseMappingWithMembership;

@end
