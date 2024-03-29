//
//  StatsViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/2/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "LeaderboardViewController.h"
#import "UIBarButtonItem+Additions.h"
#import "League.h"
#import "Membership.h"
#import "LeaderCell.h"

@interface LeaderboardViewController ()

@end

@implementation LeaderboardViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.showsPullToRefresh = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LeaderCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"LeaderCell"];
    
    self.measuringCell = [self.tableView dequeueReusableCellWithIdentifier:@"LeaderCell"];
    
    NSURL *url = [[RKObjectManager sharedManager].router URLForRelationship:@"leaderboard" ofObject:self.membership.league method:RKRequestMethodGET];
    self.fetchRequest = [RKArrayOfFetchRequestFromBlocksWithURL([RKObjectManager sharedManager].fetchRequestBlocks, url) lastObject];
    self.managedObjectContext = [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
    
    self.reloading = YES;
    [self loadData];
}

-(void)loadData{
    [[RKObjectManager sharedManager] getObjectsAtPathForRelationship:@"leaderboard" ofObject:self.membership.league parameters:nil
     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
         self.reloading = NO;
         DLog(@"Result is %@", mappingResult);
     }
     failure:^(RKObjectRequestOperation *operation, NSError *error){
         self.reloading = NO;
         DLog(@"Error is %@", error);
     }];
}

-(void)homeTouched{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Membership *membership = (Membership *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    return 55;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LeaderCell *cell = (LeaderCell *)[tableView dequeueReusableCellWithIdentifier:@"LeaderCell" forIndexPath:indexPath];
    
    Membership *membership = (Membership *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.membership = membership;
    
    return cell;
}

@end
