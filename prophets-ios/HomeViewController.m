//
//  HomeViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/21/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "HomeViewController.h"
#import "RoundedClearBar.h"
#import "User.h"
#import "FFApplicationConstants.h"
#import "UIAlertView+Additions.h"
#import "FFFacebook.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    RoundedClearBar *bar = [[RoundedClearBar alloc] initWithTitle:@"Main"];
    [bar.leftButton setTitle:@"Logout" forState:UIControlStateNormal];
    [bar.leftButton addTarget:self action:@selector(logoutTouched) forControlEvents:UIControlEventTouchUpInside];
    bar.frame = CGRectMake(7, 10, 303, bar.frame.size.height);
    
    [self.view addSubview:bar];
    
    self.versionLabel.text = [NSString stringWithFormat:@"v%@", [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"]];
}

-(void)logoutTouched{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log Out" message:@"Are you sure you want to log out?"
        completionBlock:^(NSUInteger buttonIndex, UIAlertView *alert){
            if (buttonIndex == 1) {
                User *user = [User currentUser];
                [User setCurrentUser:nil];
                [FBSession.activeSession closeAndClearTokenInformation];
                [[NSNotificationCenter defaultCenter] postNotificationName:FFUserDidLogOutNotification object:nil userInfo:@{@"user":user}];
            }
        }
      cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    
    [alert show];
}

@end
