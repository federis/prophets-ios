//
//  AppDelegate.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/14/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <PonyDebugger/PonyDebugger.h>

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "User.h"
#import "FFObjectManager.h"
#import "FFRouter.h"
#import "FFApplicationConstants.h"
#import "FFDeepLinker.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    [FFObjectManager setupObjectManager];
    
    [self setupAppearances];
    
    [self.window makeKeyAndVisible];
    
    if ([User currentUser]){
        [self refreshCurrentUser];
        [self prepareForLoggedInUser];
    }
    else{
        [self showLogin];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userLoggedIn)
                                                 name:FFUserDidLogInNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userLoggedOut)
                                                 name:FFUserDidLogOutNotification
                                               object:nil];
    
#ifdef DEBUG
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    PDDebugger *debugger = [PDDebugger defaultInstance];
    [debugger connectToURL:[NSURL URLWithString:@"ws://localhost:9000/device"]];
    [debugger enableNetworkTrafficDebugging];
    [debugger forwardAllNetworkTraffic];
    [debugger enableCoreDataDebugging];
    
    [debugger addManagedObjectContext:[RKObjectManager sharedManager].managedObjectStore.persistentStoreManagedObjectContext withName:@"Persistent Store Context"];
    [debugger addManagedObjectContext:[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext withName:@"Main Queue Context"];
    
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/Testing", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/CoreData", RKLogLevelTrace);
#endif
    
    return YES;
}

-(void)loadMemberships{
    [[RKObjectManager sharedManager] getObjectsAtPathForRelationship:@"memberships" ofObject:[User currentUser] parameters:nil
     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
         DLog(@"Result is %@", mappingResult);
     }
     failure:^(RKObjectRequestOperation *operation, NSError *error){
         DLog(@"Error is %@", error);
     }];
}

-(void)refreshCurrentUser{
    [[RKObjectManager sharedManager] getObject:[User currentUser] path:nil parameters:nil
     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
         DLog(@"Result is %@", mappingResult);
     }
     failure:^(RKObjectRequestOperation *operation, NSError *error){
         DLog(@"Error is %@", error);
     }];
}

-(void)showLogin{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard_iPhone" bundle: nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LaunchNavController"];
    [self.window.rootViewController presentViewController:loginViewController animated:NO completion:^{}];
}

-(void)setupAuthTokenHeader{
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"Authorization"
                                                           value:[NSString stringWithFormat:@"Token token=\"%@\"", [User currentUser].authenticationToken]];
}

-(void)registerForPushNotifications{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert)];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    const char *data = [deviceToken bytes];
    NSMutableString* token = [NSMutableString string];
    for (int i = 0; i < [deviceToken length]; i++) {
        [token appendFormat:@"%02.2hhX", data[i]];
    }
    
    NSLog(@"deviceToken: %@", token);
    
    [[RKObjectManager sharedManager].HTTPClient postPath:@"/devices_tokens.json" parameters:@{@"device_token[value]" : token }
     success:^(AFHTTPRequestOperation *operation, id responseObject){
         NSLog(@"Device token creation succeeded");
     } failure:^(AFHTTPRequestOperation *operation, NSError *error){
         NSLog(@"Device token creation failed");
     }];
}

-(void)userLoggedIn{
    [self prepareForLoggedInUser];
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:^{}];
}

-(void)prepareForLoggedInUser{
    [self registerForPushNotifications];
    [self setupAuthTokenHeader];
    [self loadMemberships];
}

-(void)userLoggedOut{
    [self showLogin];
    
    [[RKObjectManager sharedManager].operationQueue cancelAllOperations];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"Authorization" value:nil];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSManagedObjectContext *context = [RKObjectManager sharedManager].managedObjectStore.persistentStoreManagedObjectContext;
    
    NSFetchRequest * allEntities = [[NSFetchRequest alloc] init];
    [allEntities setEntity:[NSEntityDescription entityForName:@"Resource" inManagedObjectContext:context]];
    [allEntities setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError *error = nil;
    NSArray * results = [context executeFetchRequest:allEntities error:&error];
    
    if(error){
        //continue;
    }
    
    //error handling goes here
    for (NSManagedObject * obj in results) {
        [context deleteObject:obj];
    }
    error = nil;
    if(![context save:&error]){
        DLog(@"error %@", error);
    }
}

-(void)setupAppearances{
    UIColor *separatorColor = [UIColor colorWithRed:191.0/255.0
                                              green:187.0/255.0
                                               blue:165.0/255.0
                                              alpha:1.0];
    [[UITableView appearance] setSeparatorColor:separatorColor];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{
        UITextAttributeFont : [UIFont fontWithName:@"AvenirNext-DemiBold" size:15.0]
    }];
    
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    DLog(@"Opened with url %@", url);
    FFDeepLinker *deepLinker = [[FFDeepLinker alloc] init];
    deepLinker.rootViewController = self.window.rootViewController;
    deepLinker.managedObjectContext = [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
    [deepLinker handleUrl:url];
    return YES;
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    /*NSError *error = nil;
    if (! [[RKObjectManager sharedManager].managedObjectStore. save:&error]) {
        RKLogError(@"Failed to save RestKit managed object store: %@", error);
    }*/
}

void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}

@end
