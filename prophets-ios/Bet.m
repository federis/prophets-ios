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
@dynamic amount;
@dynamic probability;
@dynamic bonus;
@dynamic payout;
@dynamic user;
@dynamic answer;

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
    return [NSString stringWithFormat:@"%@:1", [self payoutMultipler]];
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

@end
