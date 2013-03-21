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
#import "FFLabel.h"
#import "BetCell.h"
#import "Bet.h"
#import "Membership.h"
#import "League.h"

@interface BetListViewController ()

@end

@implementation BetListViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.showsPullToRefresh = YES;
    
    [self prepareHeaderView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BetCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"BetCell"];
    
    self.measuringCell = [self.tableView dequeueReusableCellWithIdentifier:@"BetCell"];
    
    NSURL *url = [[RKObjectManager sharedManager].router URLForRelationship:@"bets" ofObject:self.membership.league method:RKRequestMethodGET];
    self.fetchRequest = [RKArrayOfFetchRequestFromBlocksWithURL([RKObjectManager sharedManager].fetchRequestBlocks, url) lastObject];
    //self.fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO], [NSSortDescriptor sortDescriptorWithKey:@"answerId" ascending:NO]];
    self.managedObjectContext = [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
    //self.sectionNameKeyPath = @"answerId";
    
    FFLabel *emptyCommentsLabel = [[FFLabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    
    emptyCommentsLabel.isBold = NO;
    emptyCommentsLabel.text = @"You haven't made any bets yet";
    emptyCommentsLabel.textAlignment = NSTextAlignmentCenter;
    
    self.emptyContentFooterView = emptyCommentsLabel;
    
    self.reloading = YES;
    [self loadData];
}

-(void)loadData{
    [[RKObjectManager sharedManager] getObjectsAtPathForRelationship:@"bets" ofObject:self.membership.league parameters:nil
     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
         self.reloading = NO;
         DLog(@"Result is %@", mappingResult);
     }
     failure:^(RKObjectRequestOperation *operation, NSError *error){
         self.reloading = NO;
         DLog(@"Error is %@", error);
     }];
}

-(void)prepareHeaderView{    
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
