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
}

-(void)logoutTouched{
    [User setCurrentUser:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:FFUserDidLogOutNotification object:nil];
}

@end
