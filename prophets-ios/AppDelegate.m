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

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
#ifdef DEBUG
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/Testing", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/CoreData", RKLogLevelTrace);
#endif
    
    [FFObjectManager setupObjectManager];
    
    [self setupAppearances];
    
    [self.window makeKeyAndVisible];
    
    if ([User currentUser]){
        [self setupAuthTokenHeader];
        [self loadMemberships];
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
    [self setupAuthTokenHeader];
    [self loadMemberships];
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:^{}];
}

-(void)userLoggedOut{
    [self showLogin];
    
    NSManagedObjectContext *context = [RKObjectManager sharedManager].managedObjectStore.persistentStoreManagedObjectContext;
    
    //NSArray *entityNames = [[RKObjectManager sharedManager].managedObjectStore.managedObjectModel.entities valueForKey:@"name"];
    
    //for (NSString *entityName in entityNames) {
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
    //}
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
