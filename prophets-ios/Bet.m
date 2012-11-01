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
@dynamic user;
@dynamic answer;

-(NSString *)oddsString{
    NSDecimalNumber *one = [NSDecimalNumber decimalNumberWithString:@"1"];
    NSDecimalNumber *quotient = [one decimalNumberByDividingBy:self.probability];
    return [NSString stringWithFormat:@"%@:1", [quotient decimalNumberBySubtracting:one]];
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
