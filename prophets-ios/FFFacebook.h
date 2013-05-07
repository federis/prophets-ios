//
//  FFFacebook.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 4/24/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "FFFacebookSessionTokenCachingStrategy.h"

@class User, Bet;

@interface FFFacebook : NSObject

+(FBSession *)currentSession;
+(void)setCurrentSession:(FBSession *)session;

// FFP Logged-in user with no fbUID wants to connect their FB account to FFP
+(void)connectAccountForCurrentUser:(void (^)(void))successBlock failure:(void (^)(NSError *, NSHTTPURLResponse *))failureBlock;

// Used for login and we also attempt this first when they hit it for registration
+(void)logInViaFacebookWithSuccessHandler:(void (^)(User *))successBlock failure:(void (^)(NSError *, NSHTTPURLResponse *))failureBlock;

+(void)saveTokenDataToRemoteForUser:(User *)user withSuccessHandler:(void (^)(void))successBlock failure:(void (^)(NSError *, NSHTTPURLResponse *))failureBlock;
+(void)saveTokenDataToRemotePath:(NSString *)path forUser:(User *)user withSuccessHandler:(void (^)(void))successBlock failure:(void (^)(NSError *, NSHTTPURLResponse *))failureBlock;

@end
