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
    
    //self.showsPullToRefresh = YES;
    
    self.navigationItem.leftItemsSupplementBackButton = YES;
    UIBarButtonItem * item = [UIBarButtonItem homeButtonItemWithTarget:self action:@selector(homeTouched)];
    
    self.navigationItem.leftBarButtonItems = @[item];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MembershipCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"MembershipCell"];
    
    self.measuringCell = [self.tableView dequeueReusableCellWithIdentifier:@"MembershipCell"];
    
    NSURL *url = [[RKObjectManager sharedManager].router URLForRelationship:@"memberships" ofObject:[User currentUser] method:RKRequestMethodGET];
    self.fetchRequest = [RKArrayOfFetchRequestFromBlocksWithURL([RKObjectManager sharedManager].fetchRequestBlocks, url) lastObject];
    self.managedObjectContext = [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleObjectChangedNotification:) name:NSManagedObjectContextObjectsDidChangeNotification object:self.managedObjectContext];
    
    [[RKObjectManager sharedManager] getObjectsAtPathForRelationship:@"memberships" ofObject:[User currentUser] parameters:nil
     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
         DLog(@"Result is %@", mappingResult);
     }
     failure:^(RKObjectRequestOperation *operation, NSError *error){
         DLog(@"Error is %@", error);
     }];
}

-(void)handleObjectChangedNotification:(NSNotification *)note{
    // This is a bit of a hack because fetchedResultsController only watches for changes to the main object
    // which is the Membership in this case. We need to update cells when a membership's league changes as well
    NSSet *changed = [note.userInfo objectForKey:NSUpdatedObjectsKey];
    if(!changed) return;
    
    for (id obj in changed) {
        if ([obj isKindOfClass:[League class]]) {
            League *l = (League *)obj;
            for (Membership *mem in self.fetchedResultsController.fetchedObjects) {
                if(mem.leagueId == l.remoteId){
                    [self.fetchedResultsController.delegate controller:self.fetchedResultsController
                                                       didChangeObject:mem
                                                           atIndexPath:[self.fetchedResultsController indexPathForObject:mem]
                                                         forChangeType:NSFetchedResultsChangeUpdate
                                                          newIndexPath:[self.fetchedResultsController indexPathForObject:mem]];
                    break;
                }
            }
        }
    }
    DLog(@"%@", note.userInfo);
}

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
}

@end
