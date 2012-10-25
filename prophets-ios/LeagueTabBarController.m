//
//  LeagueTabBarController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/22/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "LeagueTabBarController.h"
#import "UIBarButtonItem+Additions.h"
#import "League.h"

@interface LeagueTabBarController ()

@end

@implementation LeagueTabBarController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.title = self.league.name;
    self.navigationItem.leftItemsSupplementBackButton = YES;
    UIBarButtonItem * item = [UIBarButtonItem homeButtonItemWithTarget:self action:@selector(homeTouched)];
    
    [self.navigationItem setLeftBarButtonItems:@[item] animated:YES];
    
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"leaguemenu_bgnd.png"]];
}

-(void)homeTouched{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
