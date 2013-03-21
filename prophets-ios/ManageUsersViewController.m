//
//  ManageUsersViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 1/30/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import <SVProgressHUD.h>

#import "ManageUsersViewController.h"
#import "AdminMembershipCell.h"
#import "Membership.h"
#import "UIAlertView+Additions.h"

@interface ManageUsersViewController ()

@end

@implementation ManageUsersViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.showsPullToRefresh = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AdminMembershipCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"AdminMembershipCell"];
    
    self.measuringCell = [self.tableView dequeueReusableCellWithIdentifier:@"AdminMembershipCell"];
    
    NSURL *url = [[RKObjectManager sharedManager].router URLForRelationship:@"memberships" ofObject:self.league method:RKRequestMethodGET];
    
    self.fetchRequest = [RKArrayOfFetchRequestFromBlocksWithURL([RKObjectManager sharedManager].fetchRequestBlocks, url) lastObject];
    self.managedObjectContext = [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
    
    FFLabel *emptyQuestionsLabel = [[FFLabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    
    emptyQuestionsLabel.isBold = NO;
    emptyQuestionsLabel.text = @"No questions found";
    emptyQuestionsLabel.textAlignment = NSTextAlignmentCenter;
    
    self.emptyContentFooterView = emptyQuestionsLabel;
    
    self.reloading = YES;
    [self loadData];
}

-(void)loadData{
    NSURL *url = [[RKObjectManager sharedManager].router URLForRelationship:@"memberships" ofObject:self.league method:RKRequestMethodGET];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:[url relativeString] parameters:nil
      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
          DLog(@"Result is %@", mappingResult);
          self.reloading = NO;
      }
      failure:^(RKObjectRequestOperation *operation, NSError *error){
          DLog(@"Error is %@", error);
          self.reloading = NO;
      }];
}

#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AdminMembershipCell *cell = (AdminMembershipCell *)[tableView dequeueReusableCellWithIdentifier:@"AdminMembershipCell" forIndexPath:indexPath];
        
    Membership *membership = (Membership *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.membership = membership;
    
    [cell.deleteButton addTarget:self action:@selector(deleteTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(IBAction)deleteTouched:(id)sender{
    Membership *membership = ((AdminMembershipCell *)[[sender superview] superview]).membership;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Member" message:@"Are you sure you want to remove this user from the league?"
        completionBlock:^(NSUInteger buttonIndex, UIAlertView *alert){
            if (buttonIndex == 1) {
                [SVProgressHUD showWithStatus:@"Deleting question" maskType:SVProgressHUDMaskTypeGradient];
                
                [[RKObjectManager sharedManager] deleteObject:membership path:nil parameters:nil
                  success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
                      [SVProgressHUD dismiss];
                      [SVProgressHUD showSuccessWithStatus:@"Question deleted"];
                  }
                  failure:^(RKObjectRequestOperation *operation, NSError *error){
                      [SVProgressHUD dismiss];
                      
                      ErrorCollection *errors = [[[error userInfo] objectForKey:RKObjectMapperErrorObjectsKey] lastObject];
                      [SVProgressHUD showErrorWithStatus:[errors messagesString]];
                      
                      DLog(@"%@", [error description]);
                  }];
            }
            else{
                [SVProgressHUD dismiss];
            }
            
        }
      cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    
    [alert show];
}

@end
