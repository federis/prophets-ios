//
//  Question.h
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

@interface Question : Resource

@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSDate * approvedAt;
@property (nonatomic, strong) NSDate * createdAt;
@property (nonatomic, strong) NSDate * updatedAt;
@property (nonatomic, strong) NSSet *answers;
@property (nonatomic, strong) NSNumber * leagueId;
@property (nonatomic, strong) League *league;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) User *approver;

@end
