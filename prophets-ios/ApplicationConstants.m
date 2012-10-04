//
//  ApplicationConstants.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/19/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "ApplicationConstants.h"

#if APP_ENV == DEV
NSString * const FFBaseUrl = @"http://55prophets.dev:3000";
NSString * const FFKeychainIdentifier = @"prophets-ios";
NSString * const FFObjectStoreName = @"prophets-ios.sqlite";

#elif APP_ENV == TEST
NSString * const FFBaseUrl = @"http://0.0.0.0:4567";
NSString * const FFKeychainIdentifier = @"prophets-test";
NSString * const FFObjectStoreName = @"RKTests.sqlite";

#elif APP_ENV == STAGING
//staging

#elif APP_ENV == PROD
//prod

#endif

//Login notifications
NSString * const FFUserDidLogInNotification = @"FFUserDidLogInNotification";
NSString * const FFUserDidLogOutNotification = @"FFUserDidLogOutNotification";