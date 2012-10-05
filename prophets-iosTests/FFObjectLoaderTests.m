//
//  FFObjectLoaderTests.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/27/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFBaseTestCase.h"
#import "FFMappingProvider.h"
#import "User.h"
#import "Membership.h"
#import "League.h"

@interface FFObjectLoaderTests : FFBaseTestCase{
    RKTestResponseLoader *responseLoader;
    NSDateFormatter *dateFormatter;
}

@end


@implementation FFObjectLoaderTests

- (void)setUp{
    [super setUp];
    
    responseLoader = [RKTestResponseLoader responseLoader];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
}

- (void)tearDown{
    [super tearDown];
    responseLoader = nil;
    dateFormatter = nil;
}

-(void)testUserTokenLoader{
    User *user = [User createEntity];
    user.email = @"test@example.com";
    user.password = @"password";
    [[RKObjectManager sharedManager] sendObject:user toResourcePath:@"/tokens" usingBlock:^(RKObjectLoader *loader) {
        loader.delegate = responseLoader;
        loader.method = RKRequestMethodPOST;
        loader.serializationMIMEType = RKMIMETypeJSON;
        [loader.serializationMapping mapAttributes:@"password", nil];
        loader.targetObject = nil;
    }];
    
    [responseLoader waitForResponse];
    
    STAssertEquals(YES, responseLoader.wasSuccessful, nil);
    User *u = [responseLoader.objects objectAtIndex:0];
    STAssertNotNil(u, @"Expected issue not to be nil");
    STAssertEqualObjects(u.name, @"Ben Roesch", @"User's name is incorrect");
    STAssertEqualObjects(u.userId, [NSNumber numberWithInt:1], @"User's id is incorrect");
    STAssertEqualObjects(u.email, @"bcroesch@gmail.com", @"User's email is incorrect");
    STAssertEqualObjects(u.authenticationToken, @"fAcHvsHHwo13kxFYeFLL", @"User's auth token is incorrect");
    
    STAssertEqualObjects([dateFormatter stringFromDate:u.createdAt], @"2012-08-10T00:12:17Z", @"User's createdAt date is incorrect");
    STAssertEqualObjects([dateFormatter stringFromDate:u.updatedAt], @"2012-09-26T17:25:06Z", @"User's updatedAt date is incorrect");
}

-(void)testMembershipLoader{
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/memberships" delegate:responseLoader];
    [responseLoader waitForResponse];
    
    STAssertTrue(responseLoader.objects.count == 3, @"Should have loaded 3 memberships");
    
    Membership *membership = [responseLoader.objects objectAtIndex:0];
    STAssertEqualObjects(membership.membershipId, [NSNumber numberWithInt:1], @"Membership id is incorrect");
    STAssertEqualObjects(membership.role, [NSNumber numberWithInt:1], @"Membership role is incorrect");
    STAssertEqualObjects(membership.balance, [NSDecimalNumber numberWithInt:10000], @"Membership balance is incorrect");
    
    STAssertEqualObjects([dateFormatter stringFromDate:membership.createdAt], @"2012-10-01T01:32:30Z", @"Membership createdAt is incorrect");
    STAssertEqualObjects([dateFormatter stringFromDate:membership.updatedAt], @"2012-10-01T01:32:30Z", @"Membership createdAt is incorrect");
    
    League *league = membership.league;
    STAssertEqualObjects(league.leagueId, [NSNumber numberWithInt:1], @"League id is incorrect");
    STAssertTrue(league.isPrivate, @"League should not be private");
    STAssertEqualObjects(league.maxBet, [NSNumber numberWithInt:1000], @"League max bet is incorrect");
    STAssertEqualObjects(league.initialBalance, [NSNumber numberWithInt:10000], @"League initial balance is incorrect");
    STAssertEqualObjects(league.name, @"the league 1", @"League name is incorrect");
    
    STAssertEqualObjects([dateFormatter stringFromDate:league.createdAt], @"2012-10-01T01:32:30Z", @"Membership createdAt is incorrect");
    STAssertEqualObjects([dateFormatter stringFromDate:league.updatedAt], @"2012-10-01T01:32:30Z", @"Membership createdAt is incorrect");
    
}

@end
