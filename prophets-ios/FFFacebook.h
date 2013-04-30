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

@class User;

@interface FFFacebook : NSObject

+(void)openSessionForLoggedInUser;

+(void)logInViaFacebookWithSuccessHandler:(void (^)(User *))successBlock failure:(void (^)(NSError *, NSHTTPURLResponse *))failureBlock;

+(void)saveTokenDataToRemoteForUser:(User *)user withSuccessHandler:(void (^)(void))successBlock failure:(void (^)(NSError *, NSHTTPURLResponse *))failureBlock;

@end
