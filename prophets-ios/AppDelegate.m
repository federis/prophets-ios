//
//  AppDelegate.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/14/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <RestKit/RestKit.h>

#import "AppDelegate.h"
#import "FFMappingProvider.h"
#import "User.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    RKObjectManager* objectManager = [RKObjectManager managerWithBaseURLString:FFBaseUrl];
    RKManagedObjectStore* objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:@"prophets-ios.sqlite"];
    objectManager.objectStore = objectStore;
    objectManager.mappingProvider = [FFMappingProvider mappingProviderWithObjectStore:objectStore];
    return YES;
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    NSError *error = nil;
    if (! [[RKObjectManager sharedManager].objectStore save:&error]) {
        RKLogError(@"Failed to save RestKit managed object store: %@", error);
    }
}

@end
