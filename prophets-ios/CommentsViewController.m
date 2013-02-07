//
//  CommentsViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/2/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "CommentsViewController.h"
#import "UIBarButtonItem+Additions.h"
#import "Utilities.h"
#import "FFLabel.h"
#import "ClearButton.h"
#import "Membership.h"
#import "League.h"
#import "User.h"
#import "Comment.h"
#import "CommentCell.h"
#import "CommentFormViewController.h"

@interface CommentsViewController ()

@end

@implementation CommentsViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.showsPullToRefresh = YES;
    
    self.navigationItem.leftItemsSupplementBackButton = YES;
    UIBarButtonItem * item = [UIBarButtonItem homeButtonItemWithTarget:self action:@selector(homeTouched)];
    
    self.navigationItem.leftBarButtonItems = @[item];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"CommentCell"];
    
    self.measuringCell = [self.tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    
    NSURL *url = [[RKObjectManager sharedManager].router URLForRelationship:@"comments" ofObject:self.membership.league method:RKRequestMethodGET];
    
    self.fetchRequest = [RKArrayOfFetchRequestFromBlocksWithURL([RKObjectManager sharedManager].fetchRequestBlocks, url) lastObject];
    self.managedObjectContext = [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
    
    FFLabel *emptyCommentsLabel = [[FFLabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    
    emptyCommentsLabel.isBold = NO;
    emptyCommentsLabel.text = @"No one has commented yet";
    emptyCommentsLabel.textAlignment = NSTextAlignmentCenter;
    
    self.emptyContentFooterView = emptyCommentsLabel;
    
    self.reloading = YES;
    [self loadData];
}

-(void)loadData{
    [[RKObjectManager sharedManager] getObjectsAtPathForRelationship:@"comments" ofObject:self.membership.league parameters:nil
     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
         //Fetched Results Controller will automatically refresh after operation completes
         self.reloading = NO;
         DLog(@"Success");
     }
     failure:^(RKObjectRequestOperation *operation, NSError *error){
         self.reloading = NO;
         DLog(@"Error is %@", error);
     }];
}

-(void)homeTouched{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)newCommentTouched{
    [self performSegueWithIdentifier:@"ShowCommentForm" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ShowCommentForm"]) {
        CommentFormViewController *commentFormVC = (CommentFormViewController *)[segue destinationViewController];
        if (sender == nil) { //then it is a new comment
            commentFormVC.league = self.membership.league;
        }
        else if([sender isKindOfClass:[Comment class]]){
            commentFormVC.existingComment = sender;
        }
    }
}

#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 320, 30)];
    
    UIImageView *bubbles = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"conversation_bubbles.png"]];
    bubbles.frame = SameSizeRectAt(10, 10, bubbles.frame);
    
    FFLabel *commentLabel = [[FFLabel alloc] initWithFrame:CGRectMake(50, 10, 80, 30)];
    commentLabel.text = @"Club Room";
    
    ClearButton *newCommentButton = [[ClearButton alloc] initWithFrame:CGRectMake(173, 10, 120, 30)];
    [newCommentButton setTitle:@"New Comment" forState:UIControlStateNormal];
    [newCommentButton addTarget:self action:@selector(newCommentTouched) forControlEvents:UIControlEventTouchUpInside];
    
    [v addSubview:bubbles];
    [v addSubview:commentLabel];
    [v addSubview:newCommentButton];
    
    return v;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Comment *comment = (Comment *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    return [self.measuringCell heightForCellWithComment:comment];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentCell *cell = (CommentCell *)[tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    
    Comment *comment = (Comment *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.comment = comment;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    Comment *comment = (Comment *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    if (self.membership.isAdmin || [comment.userId isEqualToNumber:[User currentUser].remoteId]) {
        [self performSegueWithIdentifier:@"ShowCommentForm" sender:comment];
    }
}

@end
