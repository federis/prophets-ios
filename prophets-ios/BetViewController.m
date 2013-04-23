//
//  BetViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 4/22/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import <SVProgressHUD.h>

#import "BetViewController.h"
#import "BetCell.h"
#import "CommentCell.h"
#import "CommentsController.h"
#import "CommentFormViewController.h"
#import "Membership.h"
#import "Comment.h"
#import "User.h"
#import "Bet.h"

@interface BetViewController ()

@end

@implementation BetViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    NSString *betCellName = NSStringFromClass([BetCell class]);
    [self.tableView registerNib:[UINib nibWithNibName:betCellName bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:betCellName];
    
    NSString *commentCellName = NSStringFromClass([CommentCell class]);
    [self.tableView registerNib:[UINib nibWithNibName:commentCellName bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:commentCellName];
    
    self.measuringCell = [self.tableView dequeueReusableCellWithIdentifier:betCellName];
    self.commentMeasuringCell = [self.tableView dequeueReusableCellWithIdentifier:commentCellName];
    
    [Bet fetchAndLoadById:self.betId fromManagedObjectContext:[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext
     beforeRemoteLoad:^(Resource *resource){
         if (!self.bet) {
            [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeGradient];
         }
     }
     loaded:^(Resource * resource){
         self.bet = (Bet *)resource;
         [self setupCommentsController];
     }
     loadedRemote:^(Resource * resource){
         if (!self.bet) {
             [SVProgressHUD dismiss];
             self.bet = (Bet *)resource;
             [self setupCommentsController];
             [self.tableView reloadData];
         }
         else{
             [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
         }
     }
     failure:^(NSError *error){
         DLog(@"Error laoding bet: %@", [error description]);
     }];
}

-(void)setupCommentsController{
    self.commentsController = [[CommentsController alloc] initWithBet:self.bet];
    self.commentsController.tableView = self.tableView;
    [self.commentsController fetchComments];
    [self loadCommentsFromRemote];
}

-(void)loadCommentsFromRemote{
    [[RKObjectManager sharedManager] getObjectsAtPathForRelationship:@"comments" ofObject:self.bet parameters:nil
     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
         //Fetched Results Controller will automatically refresh after operation completes
         DLog(@"Success");
     }
     failure:^(RKObjectRequestOperation *operation, NSError *error){
         DLog(@"Error is %@", error);
     }];
}

-(void)newCommentTouched{
    [self performSegueWithIdentifier:@"ShowCommentForm" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ShowCommentForm"]){
        CommentFormViewController *commentFormVC = (CommentFormViewController *)[segue destinationViewController];
        if (sender == nil) { //then it is a new comment
            commentFormVC.bet = self.bet;
        }
        else if([sender isKindOfClass:[Comment class]]){ //existing comment
            commentFormVC.existingComment = sender;
        }
    }
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1){
        return 60;
    }
    
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        
        UIImageView *diamonds = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"diamonds.png"]];
        diamonds.center = CGPointMake(v.center.x, 8);
        
        UIImageView *bubbles = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"conversation_bubbles.png"]];
        bubbles.frame = SameSizeRectAt(10, 20, bubbles.frame);
        
        FFLabel *commentLabel = [[FFLabel alloc] initWithFrame:CGRectMake(50, 20, 80, 30)];
        commentLabel.text = @"Comments";
        
        ClearButton *newCommentButton = [[ClearButton alloc] initWithFrame:CGRectMake(173, 20, 120, 30)];
        [newCommentButton setTitle:@"New Comment" forState:UIControlStateNormal];
        [newCommentButton addTarget:self action:@selector(newCommentTouched) forControlEvents:UIControlEventTouchUpInside];
        
        [v addSubview:diamonds];
        [v addSubview:bubbles];
        [v addSubview:commentLabel];
        [v addSubview:newCommentButton];
        
        return v;
    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.bet) {
        return 2; //bet and comments
    }
    else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0)
        return 1;
    else
        return [self.commentsController numberofComments];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return [self.measuringCell heightForCellWithBet:self.bet];
    }
    else{
        Comment *comment = [self.commentsController commentAtRow:indexPath.row];
        return [self.commentMeasuringCell heightForCellWithComment:comment];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) { //bet
        BetCell *cell = (BetCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BetCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.bet = self.bet;
        
        return cell;
    }
    else{ //comments
        CommentCell *cell = (CommentCell *)[tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
        
        Comment *comment = [self.commentsController commentAtRow:indexPath.row];
        cell.comment = comment;
        
        return cell;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 1) {
        Comment *comment = [self.commentsController commentAtRow:indexPath.row];
        if (self.membership.isAdmin || [comment.userId isEqualToNumber:[User currentUser].remoteId]) {
            [self performSegueWithIdentifier:@"ShowCommentForm" sender:comment];
        }
    }
}

@end
