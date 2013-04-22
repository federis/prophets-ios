//
//  ActivityViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 4/22/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import "ActivityViewController.h"
#import "Activity.h"
#import "Membership.h"
#import "LeaguePerformanceView.h"
#import "ActivityCell.h"
#import "AnswersViewController.h"
#import "NSManagedObjectContext+Additions.h"

@interface ActivityViewController ()

@end

@implementation ActivityViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.showsPullToRefresh = YES;
    
    [self prepareHeaderView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ActivityCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"ActivityCell"];
    
    self.measuringCell = [self.tableView dequeueReusableCellWithIdentifier:@"ActivityCell"];
    
    NSURL *url = [[RKObjectManager sharedManager].router URLForRelationship:@"activities" ofObject:self.membership.league method:RKRequestMethodGET];
    self.fetchRequest = [RKArrayOfFetchRequestFromBlocksWithURL([RKObjectManager sharedManager].fetchRequestBlocks, url) lastObject];
    self.managedObjectContext = [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
    
    FFLabel *emptyCommentsLabel = [[FFLabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    
    emptyCommentsLabel.isBold = NO;
    emptyCommentsLabel.text = @"No activity in this league yet";
    emptyCommentsLabel.textAlignment = NSTextAlignmentCenter;
    
    self.emptyContentFooterView = emptyCommentsLabel;
    
    self.reloading = YES;
    [self loadData];
}

-(void)loadData{
    [[RKObjectManager sharedManager] getObjectsAtPathForRelationship:@"activities" ofObject:self.membership.league parameters:nil
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
    Activity *activity = (Activity *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    return [self.measuringCell heightForCellWithActivity:activity];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ActivityCell *cell = (ActivityCell *)[tableView dequeueReusableCellWithIdentifier:@"ActivityCell" forIndexPath:indexPath];
    
    Activity *activity = (Activity *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.activity = activity;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Activity *activity = (Activity *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard_iPhone" bundle: nil];
    
    if ([activity.feedableType isEqualToString:@"Bet"]) {
        
    }
    else if ([activity.feedableType isEqualToString:@"Question"]){
        AnswersViewController *answersVC = [storyboard instantiateViewControllerWithIdentifier:@"AnswersViewController"];
        answersVC.membership = self.membership;
        answersVC.question = [[self.managedObjectContext fetchObjectsForEntityName:@"Question" withPredicate:@"remoteId == %@", activity.feedableId] anyObject];
        
        [self.navigationController pushViewController:answersVC animated:YES];
    }
}

@end
