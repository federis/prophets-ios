//
//  ApplicationConstants.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/19/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "ApplicationConstants.h"

#ifdef APPLICATION_ENV == 1
NSString * const FFBaseUrl = @"http://55prophets.dev:3000";
#elif APPLICATION_ENV == 2
//test
#elif APPLICATION_ENV == 3
//staging
#elif APPLICATION_ENV == 4
//prod
#endif
