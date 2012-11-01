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
#import "Membership.h"

@interface LeagueTabBarController ()

@end

@implementation LeagueTabBarController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.title = self.membership.league.name;
    self.navigationItem.leftItemsSupplementBackButton = YES;
    UIBarButtonItem * item = [UIBarButtonItem homeButtonItemWithTarget:self action:@selector(homeTouched)];
    
    [self.navigationItem setLeftBarButtonItems:@[item] animated:YES];
    
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"leaguemenu_bgnd.png"]];
    
    for(UIViewController *vc in self.viewControllers){        
        if([vc respondsToSelector:@selector(setMembership:)]){
            [vc performSelector:@selector(setMembership:) withObject:self.membership];
        }
    }
}

-(void)homeTouched{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
