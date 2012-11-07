//
//  Bet.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/19/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "Bet.h"
#import "Answer.h"
#import "User.h"


@implementation Bet

@dynamic leagueId;
@dynamic answerId;
@dynamic amount;
@dynamic probability;
@dynamic bonus;
@dynamic payout;
@dynamic user;
@dynamic answer;

-(NSNumber *)dynamicAnswerId{
    if (self.answerId)
        return self.answerId;
    else if(self.answer && self.answer.remoteId)
        return self.answer.remoteId;
    else
        return nil;
}

-(BOOL)hasBeenJudged{
    return self.payout != nil;
}

-(NSDecimalNumber *)payoutMultipler{
    //(1/probability - 1)
    NSDecimalNumber *one = [NSDecimalNumber decimalNumberWithString:@"1"];
    NSDecimalNumber *quotient = [one decimalNumberByDividingBy:self.probability];
    return [quotient decimalNumberBySubtracting:one];
}

-(NSString *)oddsString{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:2];
    [formatter setMinimumIntegerDigits:1];
    [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    return [NSString stringWithFormat:@"%@:1", [formatter stringFromNumber:[self payoutMultipler]]];
}

-(NSDecimalNumber *)potentialPayout{
    //amount + amount * (1/probability - 1)
    NSDecimalNumber *product = [self.amount decimalNumberByMultiplyingBy:[self payoutMultipler]];
    return [self.amount decimalNumberByAdding:product];
}

+(RKEntityMapping *)responseMapping{
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([self class])
                                                   inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    
    [mapping addAttributeMappingsFromArray:@[@"amount", @"bonus", @"probability"]];
    [mapping addAttributeMappingsFromDictionary:@{
     @"id" : @"remoteId",
     @"league_id" : @"leagueId",
     @"answer_id" : @"answerId",
     @"updated_at" : @"updatedAt",
     @"created_at" : @"createdAt",
     }];
    
    return mapping;
}

+(RKEntityMapping *)responseMappingWithParentRelationships{
    RKEntityMapping *mapping = [self responseMapping];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"answer"
                                                                            toKeyPath:@"answer"
                                                                          withMapping:[Answer responseMappingWithParentRelationships]]];
    
    return mapping;    
}

+(RKMapping *)requestMapping{
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    [mapping addAttributeMappingsFromArray:@[@"amount"]];
    return mapping;
}

@end
