//
//  FFRequestTest.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/27/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFRequestTest.h"
#import "User.h"
#import "FFObjectManager.h"

@implementation FFRequestTest

- (void)setUp{
    [super setUp];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd'T'hh:mm:ss'Z'";
    self.dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
}

- (void)tearDown{
    [super tearDown];
    
    self.dateFormatter = nil;
}

@end
