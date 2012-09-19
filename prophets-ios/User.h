//
//  User.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/19/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, strong) NSNumber * userId;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSDate * createdAt;
@property (nonatomic, strong) NSDate * updatedAt;
@property (nonatomic, strong) NSSet *answers;
@property (nonatomic, strong) NSSet *judged_answers;
@property (nonatomic, strong) NSSet *bets;
@property (nonatomic, strong) NSSet *created_leagues;
@property (nonatomic, strong) NSSet *memberships;
@property (nonatomic, strong) NSSet *questions;
@property (nonatomic, strong) NSSet *approved_questions;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addAnswersObject:(NSManagedObject *)value;
- (void)removeAnswersObject:(NSManagedObject *)value;
- (void)addAnswers:(NSSet *)values;
- (void)removeAnswers:(NSSet *)values;

- (void)addJudged_answersObject:(NSManagedObject *)value;
- (void)removeJudged_answersObject:(NSManagedObject *)value;
- (void)addJudged_answers:(NSSet *)values;
- (void)removeJudged_answers:(NSSet *)values;

- (void)addBetsObject:(NSManagedObject *)value;
- (void)removeBetsObject:(NSManagedObject *)value;
- (void)addBets:(NSSet *)values;
- (void)removeBets:(NSSet *)values;

- (void)addCreated_leaguesObject:(NSManagedObject *)value;
- (void)removeCreated_leaguesObject:(NSManagedObject *)value;
- (void)addCreated_leagues:(NSSet *)values;
- (void)removeCreated_leagues:(NSSet *)values;

- (void)addMembershipsObject:(NSManagedObject *)value;
- (void)removeMembershipsObject:(NSManagedObject *)value;
- (void)addMemberships:(NSSet *)values;
- (void)removeMemberships:(NSSet *)values;

- (void)addQuestionsObject:(NSManagedObject *)value;
- (void)removeQuestionsObject:(NSManagedObject *)value;
- (void)addQuestions:(NSSet *)values;
- (void)removeQuestions:(NSSet *)values;

- (void)addApproved_questionsObject:(NSManagedObject *)value;
- (void)removeApproved_questionsObject:(NSManagedObject *)value;
- (void)addApproved_questions:(NSSet *)values;
- (void)removeApproved_questions:(NSSet *)values;

@end
