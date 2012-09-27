//
//  FFObjectLoaderTests.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/27/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>
#import <RestKit/Testing.h>

#import "FFMappingProvider.h"
#import "User.h"

@interface FFObjectLoaderTests : SenTestCase{
    FFMappingProvider *mappingProvider;
    RKTestResponseLoader *responseLoader;
    NSDateFormatter *dateFormatter;
}

@end


@implementation FFObjectLoaderTests

- (void)setUp{
    [RKTestFactory setUp];
    
    RKObjectManager *manager = [RKTestFactory objectManager]; //trigger creation of shared manager
    manager.objectStore = [RKTestFactory managedObjectStore];
    
    mappingProvider = [FFMappingProvider mappingProviderWithObjectStore:manager.objectStore];
    manager.mappingProvider = mappingProvider;
    
    responseLoader = [RKTestResponseLoader responseLoader];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
}

- (void)tearDown{
    [RKTestFactory tearDown];
    mappingProvider = nil;
    responseLoader = nil;
    dateFormatter = nil;
}

-(void)testUserTokenLoader{
    User *user = [User object];
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
    STAssertEqualObjects(u.name, @"Ben Roesch", nil);
    STAssertEqualObjects(u.userId, [NSNumber numberWithInt:1], nil);
    STAssertEqualObjects(u.email, @"bcroesch@gmail.com", nil);
    STAssertEqualObjects(u.authenticationToken, @"fAcHvsHHwo13kxFYeFLL", nil);
    
    STAssertEqualObjects([dateFormatter stringFromDate:u.createdAt], @"2012-08-10T00:12:17Z", nil);
    STAssertEqualObjects([dateFormatter stringFromDate:u.updatedAt], @"2012-09-26T17:25:06Z", nil);
}

@end
