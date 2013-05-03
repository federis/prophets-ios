//
//  User.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/19/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "Resource.h"

@class Membership;

@interface User : Resource{
    NSString *_authenticationToken;
}

@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * fbUid;
@property (nonatomic, strong) NSString * fbToken;
@property (nonatomic, strong) NSDate * fbTokenExpiresAt;
@property (nonatomic, strong) NSDate * fbTokenRefreshedAt;
@property (nonatomic, strong) NSNumber * publishBetsToFB;
@property (nonatomic, strong) NSSet *answers;
@property (nonatomic, strong) NSSet *judgedAnswers;
@property (nonatomic, strong) NSSet *bets;
@property (nonatomic, strong) NSSet *createdLeagues;
@property (nonatomic, strong) NSSet *memberships;
@property (nonatomic, strong) NSSet *questions;
@property (nonatomic, strong) NSSet *approvedQuestions;
@property (nonatomic, strong) NSNumber * wantsNotifications;
@property (nonatomic, strong) NSNumber * wantsNewQuestionNotifications;
@property (nonatomic, strong) NSNumber * wantsNewCommentNotifications;
@property (nonatomic, strong) NSNumber * wantsQuestionCreatedNotifications;

@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *currentPassword; //for updating user info

@property (nonatomic, strong) NSString *deviceToken;

-(Membership *)membershipInLeague:(id)leagueOrId;

-(NSString *)authenticationToken;
-(void)setAuthenticationToken:(NSString *)token;
+(User *)currentUser;
+(void)setCurrentUser:(User *)user;

-(void)loadTokenFromRemoteWithLoadedHandler:(void (^)(User *))loadedBlock failure:(void (^)(NSError *))failureBlock;

@end

