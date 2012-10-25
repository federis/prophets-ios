//
//  QuestionsViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/23/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <RestKit/RestKit.h>

#import "QuestionsViewController.h"
#import "UIBarButtonItem+Additions.h"
#import "User.h"

@interface QuestionsViewController ()

@end

@implementation QuestionsViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //self.showsPullToRefresh = YES;
    
    self.navigationItem.leftItemsSupplementBackButton = YES;
    UIBarButtonItem * item = [UIBarButtonItem homeButtonItemWithTarget:self action:@selector(homeTouched)];
    
    self.navigationItem.leftBarButtonItems = @[item];
    
    /*[self.tableView registerNib:[UINib nibWithNibName:@"MembershipCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"MembershipCell"];
    
    self.measuringCell = [self.tableView dequeueReusableCellWithIdentifier:@"MembershipCell"];
    */
    NSURL *url = [[RKObjectManager sharedManager].router URLForRelationship:@"memberships" ofObject:[User currentUser] method:RKRequestMethodGET];
    self.fetchRequest = RKFetchRequestFromBlocksWithURL([RKObjectManager sharedManager].fetchRequestBlocks, url);
    self.managedObjectContext = [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
    
    /*[[RKObjectManager sharedManager] getObjectsAtPathForRelationship:@"memberships" ofObject:[User currentUser] parameters:nil
     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
         DLog(@"Result is %@", mappingResult);
     }
     failure:^(RKObjectRequestOperation *operation, NSError *error){
         DLog(@"Error is %@", error);
     }];
     */
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
/*
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Membership *membership = (Membership *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    return [self.measuringCell heightForCellWithMembership:membership];
}
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*MembershipCell *cell = (MembershipCell *)[tableView dequeueReusableCellWithIdentifier:@"MembershipCell" forIndexPath:indexPath];
    
    Membership *membership = (Membership *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.membership = membership;
    
    return cell;*/
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tmp"];
}
 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*Membership *membership = (Membership *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"ShowLeague" sender:membership];*/
}

@end
