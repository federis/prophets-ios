//
//  FFBaseTestCase.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/4/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>
#import <RestKit/Testing.h>

#import "FFBaseTestCase.h"

@implementation FFBaseTestCase

- (void)setUp
{
    [RKTestFactory setUp];
}

- (void)tearDown
{
    [RKTestFactory tearDown];
}

@end
