//
//  LeagueMembershipsViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/28/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <RestKit/RestKit.h>

#import "MembershipsViewController.h"
#import "MembershipCell.h"
#import "UIBarButtonItem+Additions.h"
#import "LeagueTabBarController.h"
#import "Membership.h"
#import "League.h"
#import "User.h"

@interface MembershipsViewController ()
@end

@implementation MembershipsViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.showsPullToRefresh = YES;
    
    self.navigationItem.leftItemsSupplementBackButton = YES;
    UIBarButtonItem * item = [UIBarButtonItem homeButtonItemWithTarget:self action:@selector(homeTouched)];
    
    self.navigationItem.leftBarButtonItems = @[item];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MembershipCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"MembershipCell"];
    
    self.measuringCell = [self.tableView dequeueReusableCellWithIdentifier:@"MembershipCell"];
    
    NSURL *url = [[RKObjectManager sharedManager].router URLForRelationship:@"memberships" ofObject:[User currentUser] method:RKRequestMethodGET];
    self.fetchRequest = [RKArrayOfFetchRequestFromBlocksWithURL([RKObjectManager sharedManager].fetchRequestBlocks, url) lastObject];
    self.managedObjectContext = [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
    
    /*
    for (Membership *mem in self.fetchedResultsController.fetchedObjects) {
        [mem addObserver:self forKeyPath:@"league.name" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
        [mem addObserver:self forKeyPath:@"league.membershipsCount" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    }
    */
    
    self.reloading = YES;
    [self loadData];
}

-(void)loadData{
    [[RKObjectManager sharedManager] getObjectsAtPathForRelationship:@"memberships" ofObject:[User currentUser] parameters:nil
     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
         self.reloading = NO;
         DLog(@"Result is %@", mappingResult);
     }
     failure:^(RKObjectRequestOperation *operation, NSError *error){
         self.reloading = NO;
         DLog(@"Error is %@", error);
     }];
}

/*
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([object isKindOfClass:[Membership class]] && ([keyPath isEqual:@"league.name"] || [keyPath isEqual:@"league.membershipsCount"])) {
        if (![[change objectForKey:NSKeyValueChangeNewKey] isEqual:[change objectForKey:NSKeyValueChangeOldKey]] &&
            [[change objectForKey:NSKeyValueChangeKindKey] intValue] == NSKeyValueChangeReplacement) {
            [self.tableView reloadRowsAtIndexPaths:@[[self.fetchedResultsController indexPathForObject:object]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}
*/

/*
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)object atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    Membership *membership = (Membership *)object;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [membership addObserver:self forKeyPath:@"league.name" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
            [membership addObserver:self forKeyPath:@"league.membershipsCount" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
            break;
            
        case NSFetchedResultsChangeDelete:
            [membership removeObserver:self forKeyPath:@"league.name"];
            [membership removeObserver:self forKeyPath:@"league.membershipsCount"];
            break;
    }
    
    [super controller:controller didChangeObject:object atIndexPath:indexPath forChangeType:type newIndexPath:newIndexPath];
}
*/

-(void)homeTouched{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"ShowLeague"] && [sender isKindOfClass:[Membership class]]) {
        Membership *membership = (Membership *)sender;
        LeagueTabBarController *leagueTBC = (LeagueTabBarController *)[segue destinationViewController];
        leagueTBC.membership = membership;
    }
}

#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Membership *membership = (Membership *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    return [self.measuringCell heightForCellWithMembership:membership];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MembershipCell *cell = (MembershipCell *)[tableView dequeueReusableCellWithIdentifier:@"MembershipCell" forIndexPath:indexPath];
    
    Membership *membership = (Membership *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.membership = membership;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Membership *membership = (Membership *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"ShowLeague" sender:membership];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

/*
-(void)dealloc{
    for (Membership *membership in self.fetchedResultsController.fetchedObjects) {
        [membership removeObserver:self forKeyPath:@"league.name"];
        [membership removeObserver:self forKeyPath:@"league.membershipsCount"];
    }
}
*/

@end
