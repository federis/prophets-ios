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
#import "ApplicationConstants.h"
#import "CoreData+MagicalRecord.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    //RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    //RKLogConfigureByName("RestKit/UI", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/Testing", RKLogLevelTrace);
    
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    NSString *path = [RKApplicationDataDirectory() stringByAppendingPathComponent:FFObjectStoreName];
    [managedObjectStore addSQLitePersistentStoreAtPath:path fromSeedDatabaseAtPath:nil error:nil];
    [managedObjectStore createManagedObjectContexts];
    
    FFObjectManager* objectManager = [FFObjectManager managerWithBaseURL:[NSURL URLWithString:FFBaseUrl]];
    objectManager.managedObjectStore = managedObjectStore;
    [objectManager setupRequestDescriptors];
    [objectManager setupResponseDescriptors];
    
    [MagicalRecord setupCoreDataStackWithStoreNamed:FFObjectStoreName];
    
    [self setupAppearances];
    
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
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LaunchNavController"];
    [self.window.rootViewController presentViewController:loginViewController animated:NO completion:^{}];
}

-(void)setupAuthTokenHeader{
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"Authorization"
                                                           value:[NSString stringWithFormat:@"Token token=\"%@\"", [User currentUser].authenticationToken]];
}

-(void)setupAppearances{
    UIColor *separatorColor = [UIColor colorWithRed:191.0/255.0
                                              green:187.0/255.0
                                               blue:165.0/255.0
                                              alpha:1.0];
    [[UITableView appearance] setSeparatorColor:separatorColor];
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    /*NSError *error = nil;
    if (! [[RKObjectManager sharedManager].managedObjectStore. save:&error]) {
        RKLogError(@"Failed to save RestKit managed object store: %@", error);
    }*/
}

@end
