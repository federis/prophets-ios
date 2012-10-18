//
//  Bet.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/19/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <RestKit/RestKit.h>

#import "NSManagedObject+Additions.h"

@class Answer, User;

@interface Bet : NSManagedObject

@property (nonatomic, strong) NSNumber * betId;
@property (nonatomic, strong) NSDecimalNumber * amount;
@property (nonatomic, strong) NSDecimalNumber * probability;
@property (nonatomic, strong) NSDecimalNumber * bonus;
@property (nonatomic, strong) NSDate * createdAt;
@property (nonatomic, strong) NSDate * updatedAt;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Answer *answer;

+(RKEntityMapping *)responseMapping;
+(RKEntityMapping *)requestMapping;

@end
