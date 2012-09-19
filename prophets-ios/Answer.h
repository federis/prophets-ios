//
//  Answer.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/19/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Question, User;

@interface Answer : NSManagedObject

@property (nonatomic, strong) NSNumber * answerId;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSDecimalNumber * initialProbability;
@property (nonatomic, strong) NSDecimalNumber * currentProbability;
@property (nonatomic, strong) NSDecimalNumber * betTotal;
@property (nonatomic, strong) NSNumber * correct;
@property (nonatomic, strong) NSDate * createdAt;
@property (nonatomic, strong) NSDate * updatedAt;
@property (nonatomic, strong) NSDate * judgedAt;
@property (nonatomic, strong) Question *question;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) User *judge;
@property (nonatomic, strong) NSSet *bets;
@end

@interface Answer (CoreDataGeneratedAccessors)

- (void)addBetsObject:(NSManagedObject *)value;
- (void)removeBetsObject:(NSManagedObject *)value;
- (void)addBets:(NSSet *)values;
- (void)removeBets:(NSSet *)values;

@end
