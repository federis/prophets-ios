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
#import "UIBarButtonItem+Additions.h"

@interface JoinLeagueViewController ()

@end

@implementation JoinLeagueViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.leftItemsSupplementBackButton = YES;    
    self.navigationItem.leftBarButtonItems = @[[UIBarButtonItem homeButtonItemWithTarget:self action:@selector(homeTouched)]];
    
    NSString *cellName = NSStringFromClass([LeagueDetailCell class]);
    [self.tableView registerNib:[UINib nibWithNibName:cellName bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:cellName];
    
    self.measuringCell = (LeagueDetailCell *)[self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LeagueDetailCell class])];
}

-(void)homeTouched{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)joinOrPromptForPassword{
    if ([self.league.priv boolValue]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Password Required" message:@"Enter the league's password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit", nil];
        alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
        [alert show];
    }
    else {
        [self join:nil];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1) {
        [self join:[[alertView textFieldAtIndex:0] text]];
    }
}

-(void)join:(NSString *)password{
    [SVProgressHUD showWithStatus:@"Joining league" maskType:SVProgressHUDMaskTypeGradient];
    
    Membership *mem = (Membership *)[self.scratchContext insertNewObjectForEntityForName:@"Membership"];
    mem.leagueId = self.league.remoteId;
    
    NSDictionary *params = nil;
    if(password){
        params = @{@"league_password" : password};
    }
    
    [[RKObjectManager sharedManager] postObject:mem path:nil parameters:params
       success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
           [SVProgressHUD dismiss];
           [SVProgressHUD showSuccessWithStatus:@"League joined"];
           
           NSManagedObjectContext *context = [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
           Membership *newMem = (Membership *)[context objectWithID:[mem objectID]];
           [self showLeague:newMem];
           [self.tableView reloadData];
       }
       failure:^(RKObjectRequestOperation *operation, NSError *error){
           [SVProgressHUD dismiss];
           
           ErrorCollection *errors = [[[error userInfo] objectForKey:RKObjectMapperErrorObjectsKey] lastObject];
           [SVProgressHUD showErrorWithStatus:[errors messagesString]];
           
           DLog(@"%@", [error description]);
       }];
}

-(void)showLeague:(Membership *)membership{
    [self performSegueWithIdentifier:@"ShowLeague" sender:membership];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"ShowLeague"]) {
        LeagueTabBarController *leagueVC = (LeagueTabBarController *)[segue destinationViewController];
        if (sender && [sender isKindOfClass:[Membership class]]) {
            leagueVC.membership = (Membership *)sender;
        }
        else{
            leagueVC.membership = [[User currentUser] membershipInLeague:self.league.remoteId];
        }
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
        [footerView.button addTarget:self action:@selector(joinOrPromptForPassword) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return footerView;
}


@end
