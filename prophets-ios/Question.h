//
//  Question.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/19/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "Resource.h"

@class League, User, Answer;

@interface Question : Resource

@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSDate * approvedAt;
@property (nonatomic, strong) NSDate * completedAt;
@property (nonatomic, strong) NSDate * bettingClosesAt;
@property (nonatomic, strong) NSSet *answers;
@property (nonatomic, strong) NSNumber * betsCount;
@property (nonatomic, strong) NSNumber * commentsCount;
@property (nonatomic, strong) NSNumber * leagueId;
@property (nonatomic, strong) League *league;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) User *approver;

-(BOOL)isApproved;
-(BOOL)isOpenForBetting;
-(BOOL)allAnswersJudged;

+(RKEntityMapping *)responseMappingWithAnswers;

@end

@interface Question (CoreDataGeneratedAccessors)

- (void)addAnswersObject:(Answer *)value;
- (void)removeAnswersObject:(Answer *)value;
- (void)addAnswers:(NSSet *)values;
- (void)removeAnswers:(NSSet *)values;

@end
