//
//  FFApplicationConstants.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/19/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFApplicationConstants.h"

#if APP_ENV == DEV
NSString * const FFBaseUrl = @"http://55prophets.dev:3000";
//NSString * const FFBaseUrl = @"http://55prophets.com";
//NSString * const FFBaseUrl = @"http://10.0.1.3:3000";
NSString * const FFKeychainIdentifier = @"prophets-ios-dev";
NSString * const FFObjectStoreName = @"prophets-ios.sqlite";
NSString * const FFURLScheme = @"ffprophetsdev";

#elif APP_ENV == TEST
NSString * const FFBaseUrl = @"http://0.0.0.0:4567";
NSString * const FFKeychainIdentifier = @"prophets-test";
NSString * const FFObjectStoreName = @"RKTests.sqlite";
NSString * const FFURLScheme = @"ffprophetsdev";

#elif APP_ENV == STAGING
//staging

#elif APP_ENV == PROD
//prod
NSString * const FFBaseUrl = @"http://55prophets.com";
NSString * const FFKeychainIdentifier = @"prophets-ios";
NSString * const FFObjectStoreName = @"prophets-ios.sqlite";
NSString * const FFURLScheme = @"ffprophets";

#endif

NSString * const FFRegistrationSecret = @"7eaeaff73a42ececa4392fd99000d5f9cfa76b41";

//Login notifications
NSString * const FFUserDidLogInNotification = @"FFUserDidLogInNotification";
NSString * const FFUserDidLogOutNotification = @"FFUserDidLogOutNotification";