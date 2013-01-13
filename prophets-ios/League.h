//
//  League.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/19/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "Resource.h"

@class User;

@interface League : Resource

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSNumber * priv;
@property (nonatomic, strong) NSDecimalNumber * maxBet;
@property (nonatomic, strong) NSDecimalNumber * initialBalance;
@property (nonatomic, strong) NSNumber * membershipsCount;
@property (nonatomic, strong) NSNumber * questionsCount;
@property (nonatomic, strong) NSNumber * commentsCount;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSSet *memberships;
@property (nonatomic, strong) NSSet *questions;
@property (nonatomic, strong) NSSet *tags;
@property (nonatomic, strong) NSString *creatorName;
@property (nonatomic, strong) NSString *tagList;
@property (nonatomic, strong) NSString *password;

-(BOOL)isPrivate;
-(void)setIsPrivate:(BOOL)isPrivate;

@end
