//
//  BetListViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/29/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <RestKit/RestKit.h>

#import "BetListViewController.h"
#import "UIBarButtonItem+Additions.h"
#import "UIColor+Additions.h"
#import "BetCell.h"
#import "Bet.h"

@interface BetListViewController ()

@end

@implementation BetListViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //self.showsPullToRefresh = YES;
    
    self.navigationItem.leftItemsSupplementBackButton = YES;
    UIBarButtonItem * item = [UIBarButtonItem homeButtonItemWithTarget:self action:@selector(homeTouched)];
    self.navigationItem.leftBarButtonItems = @[item];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BetCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"BetCell"];
    
    self.measuringCell = [self.tableView dequeueReusableCellWithIdentifier:@"BetCell"];
    
    NSURL *url = [[RKObjectManager sharedManager].router URLForRelationship:@"bets" ofObject:self.league method:RKRequestMethodGET];
    self.fetchRequest = RKFetchRequestFromBlocksWithURL([RKObjectManager sharedManager].fetchRequestBlocks, url);
    self.managedObjectContext = [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
    
    [[RKObjectManager sharedManager] getObjectsAtPathForRelationship:@"bets" ofObject:self.league parameters:nil
     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
         DLog(@"Result is %@", mappingResult);
     }
     failure:^(RKObjectRequestOperation *operation, NSError *error){
         DLog(@"Error is %@", error);
     }];
}

-(void)homeTouched{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    /*
     if([segue.identifier isEqualToString:@"ShowLeague"] && [sender isKindOfClass:[Membership class]]) {
     Membership *membership = (Membership *)sender;
     LeagueTabBarController *leagueTBC = (LeagueTabBarController *)[segue destinationViewController];
     leagueTBC.league = membership.league;
     }
     */
}

#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Bet *bet = (Bet *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    return [self.measuringCell heightForCellWithBet:bet];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BetCell *cell = (BetCell *)[tableView dequeueReusableCellWithIdentifier:@"BetCell" forIndexPath:indexPath];
    
    Bet *bet = (Bet *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.bet = bet;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 108, 20)];
    headerLabel.text = @"    MY BETS";
    headerLabel.font = [UIFont fontWithName:@"Avenir Next" size:12];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor creamColor];
    return headerLabel;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*Membership *membership = (Membership *)[self.fetchedResultsController objectAtIndexPath:indexPath];
     [self performSegueWithIdentifier:@"ShowLeague" sender:membership];*/
}

@end
