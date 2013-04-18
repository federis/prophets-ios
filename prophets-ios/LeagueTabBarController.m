//
//  LeagueTabBarController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/22/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "LeagueTabBarController.h"
#import "AdminViewController.h"
#import "UIBarButtonItem+Additions.h"
#import "League.h"
#import "Membership.h"
#import "UIColor+Additions.h"

@interface LeagueTabBarController ()

@end

@implementation LeagueTabBarController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    if(!self.membership.isAdmin){
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    self.navigationItem.title = self.membership.league.name;
    self.navigationItem.leftItemsSupplementBackButton = YES;
    UIBarButtonItem * item = [UIBarButtonItem homeButtonItemWithTarget:self action:@selector(homeTouched)];
    
    [self.navigationItem setLeftBarButtonItems:@[item] animated:YES];
    
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"leaguemenu_bgnd.png"]];
    
    for(UITabBarItem *item in self.tabBar.items){
        UIImage *selected = nil;
        UIImage *unselected = nil;
        if ([item.title isEqualToString:@"Questions"]) {
            selected = [UIImage imageNamed:@"leaguemenu_allquestions_pressed.png"];
            unselected = [UIImage imageNamed:@"leaguemenu_allquestions.png"];
        }
        else if ([item.title isEqualToString:@"My Bets"]) {
            selected = [UIImage imageNamed:@"leaguemenu_mybets_pressed.png"];
            unselected = [UIImage imageNamed:@"leaguemenu_mybets.png"];
        }
        else if ([item.title isEqualToString:@"Leaderboard"]) {
            selected = [UIImage imageNamed:@"leaguemenu_stats_pressed.png"];
            unselected = [UIImage imageNamed:@"leaguemenu_stats.png"];
        }
        else if ([item.title isEqualToString:@"Club Room"]) {
            selected = [UIImage imageNamed:@"leaguemenu_clubroom_pressed.png"];
            unselected = [UIImage imageNamed:@"leaguemenu_clubroom.png"];
        }
        else if ([item.title isEqualToString:@"Settings"]) {
            selected = [UIImage imageNamed:@"leaguemenu_settings_pressed.png"];
            unselected = [UIImage imageNamed:@"leaguemenu_settings.png"];
        }
        [item setFinishedSelectedImage:selected withFinishedUnselectedImage:unselected];
        [item setTitleTextAttributes:@{
            UITextAttributeTextColor : [UIColor creamColor]
         }
                            forState:UIControlStateNormal];
    }
    
    for(UIViewController *vc in self.viewControllers){        
        if([vc respondsToSelector:@selector(setMembership:)]){
            [vc performSelector:@selector(setMembership:) withObject:self.membership];
        }
    }
}

-(void)homeTouched{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"ShowAdmin"]) {
        AdminViewController *adminVC = (AdminViewController *)[segue destinationViewController];
        adminVC.league = self.membership.league;
    }
}

@end
