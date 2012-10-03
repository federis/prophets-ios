//
//  ApplicationConstants.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/19/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "ApplicationConstants.h"

#ifdef DEV
NSString * const FFBaseUrl = @"http://55prophets.dev:3000";
#elif TEST
//test
#elif STAGING
//staging
#elif PRODUCTION
//prod
#endif

//Login notifications
NSString * const FFUserDidLogInNotification = @"FFUserDidLogInNotification";
NSString * const FFUserDidLogOutNotification = @"FFUserDidLogOutNotification";