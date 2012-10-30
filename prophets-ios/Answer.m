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
@dynamic question;
@dynamic user;
@dynamic judge;
@dynamic bets;

-(BOOL)isCorrect{
    return self.correct.boolValue;
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
