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
}

-(void)tearDown{
    [super tearDown];
    
    self.storyboard = nil;
}

@end
