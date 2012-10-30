//
//  Membership.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/19/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <RestKit/RestKit.h>

#import "Resource.h"

@class League, User;

@interface Membership : Resource

@property (nonatomic, strong) NSNumber * leagueId;
@property (nonatomic, strong) NSNumber * role;
@property (nonatomic, strong) NSDecimalNumber * balance;
@property (nonatomic, strong) NSDate * createdAt;
@property (nonatomic, strong) NSDate * updatedAt;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) League *league;

-(NSString *)balanceString;

+(RKEntityMapping *)requestMapping;

@end
