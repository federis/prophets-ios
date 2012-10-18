//
//  User.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/19/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <RestKit/RestKit.h>

@interface User : NSManagedObject{
    NSString *_authenticationToken;
}

@property (nonatomic, strong) NSNumber * userId;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSDate * createdAt;
@property (nonatomic, strong) NSDate * updatedAt;
@property (nonatomic, strong) NSSet *answers;
@property (nonatomic, strong) NSSet *judgedAnswers;
@property (nonatomic, strong) NSSet *bets;
@property (nonatomic, strong) NSSet *createdLeagues;
@property (nonatomic, strong) NSSet *memberships;
@property (nonatomic, strong) NSSet *questions;
@property (nonatomic, strong) NSSet *approvedQuestions;

@property (nonatomic, strong) NSString *password;

-(NSString *)authenticationToken;
-(void)setAuthenticationToken:(NSString *)token;
+(User *)currentUser;
+(void)setCurrentUser:(User *)user;

+(RKEntityMapping *)responseMapping;
+(RKEntityMapping *)requestMapping;

@end

