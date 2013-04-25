//
//  FFFacebook.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 4/24/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FFFacebook : NSObject

+(FBSession *)sharedSession;
+(void)setSharedSession:(FBSession *)session;

+(void)logInWithFacebookSession:(FBSession *)session success:(void (^)(void))successBlock failure:(void (^)(NSError *))failureBlock;

@end
