//
//  LaunchViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/7/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "LaunchViewController.h"

@interface LaunchViewController ()

@end

@implementation LaunchViewController

- (void)viewDidLoad{
    [super viewDidLoad]; 
    UIEdgeInsets insets = UIEdgeInsetsMake(14, 5, 14, 5);
    UIImage *buttonImage = [[UIImage imageNamed:@"clear_button.png"] resizableImageWithCapInsets:insets];
    
    [self.loginButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.registerButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
}

@end
