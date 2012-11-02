//
//  Answer.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/19/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "Answer.h"
#import "Question.h"
#import "User.h"


@implementation Answer

@dynamic content;
@dynamic initialProbability;
@dynamic currentProbability;
@dynamic betTotal;
@dynamic correct;
@dynamic judgedAt;
@dynamic correctnessKnownAt;
@dynamic question;
@dynamic user;
@dynamic judge;
@dynamic bets;

-(BOOL)hasBeenJudged{
    return self.judgedAt != nil;
}

-(BOOL)isCorrect{
    return self.correct.boolValue;
}

-(BOOL)isOpenForBetting{
    return !self.hasBeenJudged && self.question.isOpenForBetting;
}

-(NSDate *)bettingEndedAt{
    if (self.isOpenForBetting) return nil;
    
    //There are 3 possible times that betting technically ended
    // -correctnessKnownAt: The answer was marked as being known prior to judgedAt and all later bets were invalidated
    // -judgedAt: The answer was judged before question close of betting, but was not given a correctnessKnownAt prior to the judging time
    // -question.bettingClosesAt: Betting closed normally
    
    NSMutableArray *potentialDates = [NSMutableArray array];
    if(self.judgedAt) [potentialDates addObject:self.judgedAt];
    if(self.correctnessKnownAt) [potentialDates addObject:self.correctnessKnownAt];
    if(self.question.bettingClosesAt) [potentialDates addObject:self.question.bettingClosesAt];
    
    NSAssert([potentialDates count] > 0, @"Invalid state. All potential dates are nil.");
    
    NSArray *sortedDates = [potentialDates sortedArrayUsingSelector:@selector(compare:)];
    return [sortedDates objectAtIndex:0];
}

-(void)setIsCorrect:(BOOL)isCorrect{
    self.correct = [NSNumber numberWithBool:isCorrect];
}

- (void)setNilValueForKey:(NSString *)key {
    if ([key isEqualToString:@"isCorrect"]) {
        self.correct = nil;
    }
    else {
        [super setNilValueForKey:key];
    }
}


+(RKEntityMapping *)responseMapping{
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([self class])
                                                   inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    
    [mapping addAttributeMappingsFromArray:@[@"content"]];
    [mapping addAttributeMappingsFromDictionary:@{
     @"id" : @"remoteId",
     @"bet_total" : @"betTotal",
     @"current_probability" : @"currentProbability",
     @"initial_probability" : @"initialProbability",
     @"correct" : @"isCorrect",
     @"judged_at" : @"judgedAt",
     @"correctness_known_at" : @"correctnessKnownAt",
     @"updated_at" : @"updatedAt",
     @"created_at" : @"createdAt"
     }];
        
    return mapping;
}

+(RKEntityMapping *)responseMappingWithParentRelationships{
    RKEntityMapping *mapping = [self responseMapping];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"question"
                                                                            toKeyPath:@"question"
                                                                          withMapping:[Question responseMapping]]];

    return mapping;
}

@end
