//
//  League.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/19/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <RestKit/RestKit.h>

@class User;

@interface League : NSManagedObject

@property (nonatomic, strong) NSNumber * leagueId;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSNumber * priv;
@property (nonatomic, strong) NSDecimalNumber * maxBet;
@property (nonatomic, strong) NSDecimalNumber * initialBalance;
@property (nonatomic, strong) NSDate * createdAt;
@property (nonatomic, strong) NSDate * updatedAt;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSSet *memberships;
@property (nonatomic, strong) NSSet *questions;

-(BOOL)isPrivate;
-(void)setIsPrivate:(BOOL)isPrivate;

+(RKEntityMapping *)entityMapping;

@end
