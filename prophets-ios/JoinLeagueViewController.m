//
//  JoinLeagueViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 12/7/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "JoinLeagueViewController.h"
#import "League.h"
#import "User.h"
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
    /*
    NSURL *url = [[RKObjectManager sharedManager].router URLForRouteNamed:@"approve_question" method:nil object:self.question];
    
    [SVProgressHUD showWithStatus:@"Joining league" maskType:SVProgressHUDMaskTypeGradient];
    
    [[RKObjectManager sharedManager] putObject:self.question path:[url relativeString] parameters:nil
       success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
           [SVProgressHUD dismiss];
           [SVProgressHUD showSuccessWithStatus:@"Question published"];
           
           [self returnToLeague];
       }
       failure:^(RKObjectRequestOperation *operation, NSError *error){
           [SVProgressHUD dismiss];
           
           [SVProgressHUD showErrorWithStatus:[error description]];
           
           DLog(@"%@", [error description]);
       }];
     */
}

-(void)goToLeague{
    
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
        [footerView.button addTarget:self action:@selector(goToLeague) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        footerView = [FFTableFooterButtonView footerButtonViewForTable:self.tableView withText:@"Join"];
        [footerView.button addTarget:self action:@selector(join) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return footerView;
}


@end
