//
//  JoinLeagueViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 12/7/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <SVProgressHUD.h>
#import <RestKit/RestKit.h>

#import "JoinLeagueViewController.h"
#import "LeagueTabBarController.h"
#import "League.h"
#import "User.h"
#import "Membership.h"
#import "LeagueDetailCell.h"

@interface JoinLeagueViewController ()

@end

@implementation JoinLeagueViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    NSString *cellName = NSStringFromClass([LeagueDetailCell class]);
    [self.tableView registerNib:[UINib nibWithNibName:cellName bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:cellName];
    
    self.measuringCell = (LeagueDetailCell *)[self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LeagueDetailCell class])];
}

-(void)join{
    [SVProgressHUD showWithStatus:@"Joining league" maskType:SVProgressHUDMaskTypeGradient];
    
    Membership *mem = (Membership *)[self.scratchContext insertNewObjectForEntityForName:@"Membership"];
    mem.leagueId = self.league.remoteId;
    
    [[RKObjectManager sharedManager] postObject:mem path:nil parameters:nil
       success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
           [SVProgressHUD dismiss];
           [SVProgressHUD showSuccessWithStatus:@"League joined"];
           
           [self showLeague];
       }
       failure:^(RKObjectRequestOperation *operation, NSError *error){
           [SVProgressHUD dismiss];
           
           [SVProgressHUD showErrorWithStatus:[error description]];
           
           DLog(@"%@", [error description]);
       }];
}

-(void)showLeague{
    [self performSegueWithIdentifier:@"ShowLeague" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"ShowLeague"]) {
        LeagueTabBarController *leagueVC = (LeagueTabBarController *)[segue destinationViewController];
        leagueVC.membership = [[User currentUser] membershipInLeague:self.league.remoteId];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.measuringCell heightForCellWithLeague:self.league];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LeagueDetailCell *cell = (LeagueDetailCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LeagueDetailCell class]) forIndexPath:indexPath];
    
    cell.league = self.league;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    FFTableFooterButtonView *footerView = nil;
    
    Membership *membership = [[User currentUser] membershipInLeague:self.league.remoteId];
    if (membership) {
        footerView = [FFTableFooterButtonView footerButtonViewForTable:self.tableView withText:@"Go to League"];
        [footerView.button addTarget:self action:@selector(showLeague) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        footerView = [FFTableFooterButtonView footerButtonViewForTable:self.tableView withText:@"Join"];
        [footerView.button addTarget:self action:@selector(join) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return footerView;
}


@end
