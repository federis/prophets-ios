//
//  BetListViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/29/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <RestKit/RestKit.h>

#import "BetListViewController.h"
#import "LeaguePerformanceView.h"
#import "UIBarButtonItem+Additions.h"
#import "UIColor+Additions.h"
#import "BetCell.h"
#import "Bet.h"
#import "Membership.h"
#import "League.h"

@interface BetListViewController ()

@end

@implementation BetListViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //self.showsPullToRefresh = YES;
    
    [self prepareHeaderView];
    
    self.navigationItem.leftItemsSupplementBackButton = YES;
    UIBarButtonItem * item = [UIBarButtonItem homeButtonItemWithTarget:self action:@selector(homeTouched)];
    self.navigationItem.leftBarButtonItems = @[item];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BetCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"BetCell"];
    
    self.measuringCell = [self.tableView dequeueReusableCellWithIdentifier:@"BetCell"];
    
    NSURL *url = [[RKObjectManager sharedManager].router URLForRelationship:@"bets" ofObject:self.membership.league method:RKRequestMethodGET];
    self.fetchRequest = [RKArrayOfFetchRequestFromBlocksWithURL([RKObjectManager sharedManager].fetchRequestBlocks, url) lastObject];
    self.managedObjectContext = [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
    self.sectionNameKeyPath = @"remoteId";
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
    
    [[RKObjectManager sharedManager] getObjectsAtPathForRelationship:@"bets" ofObject:self.membership.league parameters:nil
     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
         DLog(@"Result is %@", mappingResult);
     }
     failure:^(RKObjectRequestOperation *operation, NSError *error){
         DLog(@"Error is %@", error);
     }];
}

-(void)prepareHeaderView{
    UIEdgeInsets insets = UIEdgeInsetsMake(4, 5, 4, 5);
    UIImage *buttonImage = [[UIImage imageNamed:@"clear_button_insets.png"] resizableImageWithCapInsets:insets];
    
    [self.timeSortButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.performanceSortButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    
    LeaguePerformanceView *performanceView = [[LeaguePerformanceView alloc] init];
    [performanceView setMembership:self.membership];
    [self.tableView.tableHeaderView addSubview:performanceView];
}

-(void)homeTouched{
    [self dismissViewControllerAnimated:YES completion:^{}];
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

@end
