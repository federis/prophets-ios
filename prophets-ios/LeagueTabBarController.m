//
//  LeagueTabBarController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/22/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "LeagueTabBarController.h"
#import "UIBarButtonItem+Additions.h"

@interface LeagueTabBarController ()

@end

@implementation LeagueTabBarController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.leftItemsSupplementBackButton = YES;
    UIBarButtonItem * item = [UIBarButtonItem homeButtonItemWithTarget:nil action:nil];
    
    [self.navigationItem setLeftBarButtonItems:@[item] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
