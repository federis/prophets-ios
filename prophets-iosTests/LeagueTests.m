//
//  LeagueTest.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/3/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFLogicTest.h"
#import "League.h"

@interface LeagueTests : FFLogicTest

@end


@implementation LeagueTests

- (void)setUp{
    [super setUp];
}

- (void)tearDown{
    [super tearDown];
}

-(void)testIsPrivateSetter{
    League *league = [Factories leagueFactory];
    
    league.isPrivate = YES;
    STAssertTrue([league.priv intValue] == 1, @"League isPrivate setter did not correctly set true value");
    league.isPrivate = NO;
    STAssertTrue([league.priv intValue] == 0, @"League isPrivate setter did not correctly set false value");
}

-(void)testIsPrivateGetter{
    League *league = [Factories leagueFactory];
    
    league.priv = [NSNumber numberWithBool:YES];
    STAssertTrue(league.isPrivate, @"League isPrivate getter did not correctly get true value");
    league.priv = [NSNumber numberWithBool:NO];
    STAssertTrue([league.priv intValue] == 0, @"League isPrivate getter did not correctly get false value");
}

@end
