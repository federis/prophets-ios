//
//  Answer.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/19/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "Resource.h"

@class Question, User;

@interface Answer : Resource

@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSDecimalNumber * initialProbability;
@property (nonatomic, strong) NSDecimalNumber * currentProbability;
@property (nonatomic, strong) NSDecimalNumber * betTotal;
@property (nonatomic, strong) NSNumber * betsCount;
@property (nonatomic, strong) NSNumber * correct;
@property (nonatomic, strong) NSDate * judgedAt;
@property (nonatomic, strong) NSDate * correctnessKnownAt;
@property (nonatomic, strong) NSNumber * questionId;
@property (nonatomic, strong) Question *question;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) User *judge;
@property (nonatomic, strong) NSSet *bets;

-(BOOL)isCorrect;
-(void)setIsCorrect:(BOOL)isCorrect;

-(BOOL)hasBeenJudged;
-(BOOL)isOpenForBetting;
-(NSDate *)bettingEndedAt;
-(NSString *)currentOddsString;
-(NSString *)dollarBetPayoutString;

+(RKEntityMapping *)responseMappingWithQuestion;

@end

