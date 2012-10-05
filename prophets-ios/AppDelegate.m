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
#import "LoginViewController.h"
#import "User.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{        
    //RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    //RKLogConfigureByName("RestKit/UI", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/Testing", RKLogLevelTrace);
    
    RKObjectManager* objectManager = [RKObjectManager managerWithBaseURLString:FFBaseUrl];
    RKManagedObjectStore* objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:FFObjectStoreName];
    objectManager.objectStore = objectStore;
    objectManager.mappingProvider = [FFMappingProvider mappingProviderWithObjectStore:objectStore];
    
    [RKClient sharedClient].cachePolicy = RKRequestCachePolicyNone;
    
    [self.window makeKeyAndVisible];
    
    if ([User currentUser])
        [self setupAuthTokenHeader];
    else
        [self showLogin];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setupAuthTokenHeader)
                                                 name:FFUserDidLogInNotification
                                               object:nil];
    
    return YES;
}

-(void)showLogin{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard_iPhone" bundle: nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"login"];
    [self.window.rootViewController presentModalViewController:loginViewController animated:NO];
}

-(void)setupAuthTokenHeader{
    RKClient *client = [RKObjectManager sharedManager].client;
    [client.HTTPHeaders setObject:[NSString stringWithFormat:@"Token token=\"%@\"", [User currentUser].authenticationToken]
                           forKey:@"Authorization"];
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    NSError *error = nil;
    if (! [[RKObjectManager sharedManager].objectStore save:&error]) {
        RKLogError(@"Failed to save RestKit managed object store: %@", error);
    }
}

@end
