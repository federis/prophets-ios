//
//  FFBaseTest.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/31/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFBaseTest.h"
#import "FFObjectManager.h"
#import "User.h"

@implementation FFBaseTest

- (void)setUp{
    [RKTestFactory setUp];
    [FFObjectManager setupObjectManager];
}

- (void)tearDown{
    [RKTestFactory tearDown];
}

@end
