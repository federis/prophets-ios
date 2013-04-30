//
//  FFFacebookSession.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 4/30/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import "FFFacebookSession.h"
#import <FacebookSDK/FBAccessTokenData.h>

@interface FFFacebookSession()

@property(readwrite, copy) NSDate *attemptedRefreshDate;

@end

static int const FBTokenExtendThresholdSeconds = 24; //* 60 * 60;  // day
static int const FBTokenRetryExtendSeconds = 60 * 60;           // hour

@implementation FFFacebookSession

- (BOOL)shouldExtendAccessToken {
    BOOL result = NO;
    NSDate *now = [NSDate date];
    
    if (self.isOpen &&
        [now timeIntervalSinceDate:self.attemptedRefreshDate] > FBTokenRetryExtendSeconds &&
        [now timeIntervalSinceDate:self.accessTokenData.refreshDate] > FBTokenExtendThresholdSeconds) {
        result = YES;
        self.attemptedRefreshDate = now;
    }
    return result;
}

@end
