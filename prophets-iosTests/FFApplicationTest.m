//
//  FFApplicationTest.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/30/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFApplicationTest.h"

@implementation FFApplicationTest

-(void)setUp{
    [super setUp];
    
    self.storyboard = [UIStoryboard storyboardWithName:@"Storyboard_iPhone" bundle:nil];
    
    /*NSBundle *testTargetBundle = [NSBundle bundleWithIdentifier:@"com.federisgroup.prophets-iosTests"];
    NSArray *bundles = [NSBundle allBundles];
    [RKTestFixture setFixtureBundle:testTargetBundle];*/
}

-(void)tearDown{
    [super tearDown];
    
    self.storyboard = nil;
}

@end
