//
//  LeagueListViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 12/2/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "LeagueListViewController.h"
#import "JoinLeagueViewController.h"
#import "League.h"
#import "LeagueCell.h"
#import "UIBarButtonItem+Additions.h"

@interface LeagueListViewController ()

@end

@implementation LeagueListViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    
    //self.showsPullToRefresh = YES;
    
    self.navigationItem.leftItemsSupplementBackButton = YES;
    UIBarButtonItem * item = [UIBarButtonItem homeButtonItemWithTarget:self action:@selector(homeTouched)];
    
    self.navigationItem.leftBarButtonItems = @[item];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LeagueCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"LeagueCell"];
    
    self.measuringCell = [self.tableView dequeueReusableCellWithIdentifier:@"LeagueCell"];
    
    NSURL *url = [[RKObjectManager sharedManager].router URLForRelationship:@"leagues" ofObject:self.tag method:RKRequestMethodGET];
    self.fetchRequest = [RKArrayOfFetchRequestFromBlocksWithURL([RKObjectManager sharedManager].fetchRequestBlocks, url) lastObject];
    self.managedObjectContext = [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
    
    [[RKObjectManager sharedManager] getObjectsAtPathForRelationship:@"leagues" ofObject:self.tag parameters:nil
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
    if([segue.identifier isEqualToString:@"ShowJoinLeague"] && [sender isKindOfClass:[League class]]) {
        League *league = (League *)sender;
        JoinLeagueViewController *joinLeagueVC = (JoinLeagueViewController *)[segue destinationViewController];
        joinLeagueVC.league = league;
    }
}

#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    League *league = (League *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    return [self.measuringCell heightForCellWithLeague:league];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LeagueCell *cell = (LeagueCell *)[tableView dequeueReusableCellWithIdentifier:@"LeagueCell" forIndexPath:indexPath];
    
    League *league = (League *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.league = league;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    League *league = (League *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"ShowJoinLeague" sender:league];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
