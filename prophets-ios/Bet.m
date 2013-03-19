//
//  Bet.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/19/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "Bet.h"
#import "Answer.h"
#import "Membership.h"

@implementation Bet

@dynamic membershipId;
@dynamic answerId;
@dynamic amount;
@dynamic probability;
@dynamic bonus;
@dynamic payout;
@dynamic membership;
@dynamic answer;
@dynamic invalidatedAt;

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
    return [NSString stringWithFormat:@"%@:1", [[self payoutMultipler] decimalNumberByRoundingToTwoDecimalPlaces]];
}

-(NSDecimalNumber *)potentialPayout{
    //amount + amount * (1/probability - 1)
    NSDecimalNumber *product = [self.amount decimalNumberByMultiplyingBy:[self payoutMultipler]];
    return [self.amount decimalNumberByAdding:product];
}

+(RKEntityMapping *)responseMapping{
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([self class])
                                                   inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    
    [mapping addAttributeMappingsFromArray:@[@"amount", @"bonus", @"payout", @"probability"]];
    [mapping addAttributeMappingsFromDictionary:@{
     @"id" : @"remoteId",
     @"membership_id" : @"membershipId",
     @"answer_id" : @"answerId",
     @"invalidated_at" : @"invalidatedAt",
     @"updated_at" : @"updatedAt",
     @"created_at" : @"createdAt",
     }];
    
    [mapping addConnectionForRelationship:@"membership" connectedBy:@{@"membershipId" : @"remoteId"}];
    [mapping addConnectionForRelationship:@"answer" connectedBy:@{@"answerId" : @"remoteId"}];
    
    return mapping;
}

//for use when getting list of user's bets
+(RKEntityMapping *)responseMappingWithAnswer{
    RKEntityMapping *mapping = [self responseMapping];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"answer"
                                                                            toKeyPath:@"answer"
                                                                          withMapping:[Answer responseMappingWithParentRelationships]]];
    
    return mapping;    
}

//for use when creating bet
+(RKEntityMapping *)responseMappingWithMembership{
    RKEntityMapping *mapping = [self responseMapping];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"membership"
                                                                            toKeyPath:@"membership"
                                                                          withMapping:[Membership responseMappingWithChildRelationships]]];
    
    return mapping;
}

+(RKMapping *)requestMapping{
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    [mapping addAttributeMappingsFromArray:@[@"amount"]];
    return mapping;
}

@end
