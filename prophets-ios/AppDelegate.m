//
//  AppDelegate.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/14/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <RestKit/RestKit.h>

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "User.h"
#import "FFObjectManager.h"
#import "FFRouter.h"
#import "FFApplicationConstants.h"
#import "FFDeepLinker.h"
#import "FFNotificationHandler.h"
#import "Flurry.h"
#import "FFFacebook.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    application.applicationIconBadgeNumber = 0;
    
    [FFObjectManager setupObjectManager];
    [[FFObjectManager sharedManager].HTTPClient getPath:@"/" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        // do nothing, we're not in maintenance mode
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(operation.response.statusCode == 503){
            [Utilities showOkAlertWithTitle:@"Down for Maintenance" message:@"55Prophets is currently down for maintenance. We'll be back shortly"];
        }
    }];
    
    [self setupAppearances];
    
    [self.window makeKeyAndVisible];
    
    FFDeepLinker *deepLinker = [[FFDeepLinker alloc] init];
    deepLinker.appWindow = self.window;
    deepLinker.managedObjectContext = [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
    [FFDeepLinker setSharedLinker:deepLinker];
    
    if ([User currentUser]){
        [self prepareForLoggedInUser];
        [self refreshCurrentUser];
        
        NSDictionary *noteInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (noteInfo) {
            [[FFNotificationHandler sharedHandler] handleNotification:noteInfo];
        }
    }
    else{
        [self showLogin];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userLoggedIn)
                                                 name:FFUserDidLogInNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userLoggedOut:)
                                                 name:FFUserDidLogOutNotification
                                               object:nil];
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
#ifdef DEBUG
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/Testing", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/CoreData", RKLogLevelTrace);
#endif
    
    [Flurry startSession:@"MQF63N949RPBVQJRFPPM"];
    
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

-(void)userLoggedIn{
    [self prepareForLoggedInUser];
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:^{}];
}

-(void)prepareForLoggedInUser{
    [self registerForPushNotifications];
    [self setupAuthTokenHeader];
    [self loadMemberships];
    /*
    if ([User currentUser].fbToken && ![FBSession activeSession].isOpen) {
        [FFFacebook openSessionForAlreadyConnectedUser];
    }*/
}

-(void)userLoggedOut:(NSNotification *)note{
    [self showLogin];
    
    User *user = [[note userInfo] objectForKey:@"user"];
    
    if (user && user.deviceToken) {
        [[RKObjectManager sharedManager].HTTPClient deletePath:@"/device_tokens.json" parameters:@{@"device_token[value]" : user.deviceToken }
           success:^(AFHTTPRequestOperation *operation, id responseObject){
               NSLog(@"Device token deletion succeeded");
           } failure:^(AFHTTPRequestOperation *operation, NSError *error){
               NSLog(@"Device token deletion failed");
           }];
    }
    
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
    [[FFDeepLinker sharedLinker] handleUrl:url];
    return YES;
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
    [User currentUser].deviceToken = token;
    
    [[RKObjectManager sharedManager].HTTPClient postPath:@"/device_tokens.json" parameters:@{@"device_token[value]" : token }
         success:^(AFHTTPRequestOperation *operation, id responseObject){
             NSLog(@"Device token creation succeeded");
         } failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"Device token creation failed");
         }];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err{
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    DLog(@"%@", str);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [[FFNotificationHandler sharedHandler] handleNotification:userInfo];
}

-(void)applicationWillEnterForeground:(UIApplication *)application{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*NSError *error = nil;
    if (! [[RKObjectManager sharedManager].managedObjectStore. save:&error]) {
        RKLogError(@"Failed to save RestKit managed object store: %@", error);
    }*/
}

void uncaughtExceptionHandler(NSException *exception) {
#ifdef DEBUG
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
#endif
#if APP_ENV == PROD
    [Flurry logError:@"Uncaught" message:[exception description] exception:exception];
#endif
}

@end
