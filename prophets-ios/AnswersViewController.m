//
//  AnswersViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/3/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "AnswersViewController.h"
#import "BetViewController.h"
#import "CommentsController.h"
#import "CommentFormViewController.h"
#import "CommentCell.h"
#import "LeaguePerformanceView.h"
#import "ClearButton.h"
#import "FFLabel.h"
#import "UIColor+Additions.h"
#import "Utilities.h"
#import "AnswerCell.h"
#import "Question.h"
#import "Answer.h"
#import "Comment.h"
#import "User.h"
#import "Membership.h"

@interface AnswersViewController ()

@end

@implementation AnswersViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    NSString *answerCellName = NSStringFromClass([AnswerCell class]);
    [self.tableView registerNib:[UINib nibWithNibName:answerCellName bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:answerCellName];
    
    NSString *commentCellName = NSStringFromClass([CommentCell class]);
    [self.tableView registerNib:[UINib nibWithNibName:commentCellName bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:commentCellName];
    
    self.measuringCell = [self.tableView dequeueReusableCellWithIdentifier:answerCellName];
    self.commentMeasuringCell = [self.tableView dequeueReusableCellWithIdentifier:commentCellName];
    
    self.commentsController = [[CommentsController alloc] initWithQuestion:self.question];
    self.commentsController.tableView = self.tableView;
    [self.commentsController fetchComments];
    
    [[RKObjectManager sharedManager] getObjectsAtPathForRelationship:@"comments" ofObject:self.question parameters:nil
     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
         //Fetched Results Controller will automatically refresh after operation completes
         DLog(@"Success");
     }
     failure:^(RKObjectRequestOperation *operation, NSError *error){
         DLog(@"Error is %@", error);
     }];
    
    LeaguePerformanceView *performanceView = [[LeaguePerformanceView alloc] init];
    [performanceView setMembership:self.membership];
    self.tableView.tableHeaderView = performanceView;
}

-(NSArray *)answers{
    if(_answers) return _answers;
    
    _answers = [self.question.answers allObjects];
    return _answers;
}

-(CGFloat)heightForQuestionContent{
    CGFloat descHeight = 0;
    if(self.question.desc.length > 0){
        descHeight = [Utilities heightForString:self.question.desc
                                       withFont:[UIFont fontWithName:@"AvenirNext-Regular" size:13]
                                          width:300] + 3;
    }
    
    return descHeight + [Utilities heightForString:self.question.content
                                          withFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:15]
                                             width:300];
}

-(void)newCommentTouched{
    [self performSegueWithIdentifier:@"ShowCommentForm" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"ShowBetCreation"] && [sender isKindOfClass:[Answer class]]) {
        Answer *answer = (Answer *)sender;
        BetViewController *betVC = (BetViewController *)[segue destinationViewController];
        betVC.answer = answer;
        betVC.membership = self.membership;
    }
    else if ([segue.identifier isEqualToString:@"ShowCommentForm"]){
        CommentFormViewController *commentFormVC = (CommentFormViewController *)[segue destinationViewController];
        if (sender == nil) { //then it is a new comment
            commentFormVC.question = self.question;
        }
        else if([sender isKindOfClass:[Comment class]]){ //existing comment
            commentFormVC.existingComment = sender;
        }
    }
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return [self heightForQuestionContent] + 10;
    }
    else{
        return 60;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [self heightForQuestionContent] + 10)];
        
        CGFloat questionHeight = [Utilities heightForString:self.question.content
                                                   withFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:15]
                                                      width:300];
        FFLabel *questionContentLabel = [[FFLabel alloc] initWithFrame:CGRectMake(10, 5, 300, questionHeight)];
        questionContentLabel.text = self.question.content;
        
        if (self.question.desc.length > 0) {
            UIFont *descFont = [UIFont fontWithName:@"AvenirNext-Regular" size:13];
            CGFloat descHeight = [Utilities heightForString:self.question.desc withFont:descFont width:300];
            CGRect descFrame = RectBelowRectWithSpacingAndSize(questionContentLabel.frame, 3, CGSizeMake(300, descHeight));
            FFLabel *descLabel = [[FFLabel alloc] initWithFrame:descFrame];
            
            descLabel.font = descFont;
            descLabel.text = self.question.desc;
            [v addSubview:descLabel];
        }
        
        [v addSubview:questionContentLabel];
        return v;
    }
    else{
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        
        UIImageView *diamonds = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"diamonds.png"]];
        diamonds.center = CGPointMake(v.center.x, 8);
        
        UIImageView *bubbles = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"conversation_bubbles.png"]];
        bubbles.frame = SameSizeRectAt(10, 20, bubbles.frame);
        
        FFLabel *commentLabel = [[FFLabel alloc] initWithFrame:CGRectMake(50, 20, 80, 30)];
        commentLabel.text = @"Club Room";
        
        ClearButton *newCommentButton = [[ClearButton alloc] initWithFrame:CGRectMake(173, 20, 120, 30)];
        [newCommentButton setTitle:@"New Comment" forState:UIControlStateNormal];
        [newCommentButton addTarget:self action:@selector(newCommentTouched) forControlEvents:UIControlEventTouchUpInside];
        
        [v addSubview:diamonds];
        [v addSubview:bubbles];
        [v addSubview:commentLabel];
        [v addSubview:newCommentButton];
        
        return v;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2; //answers and comments
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0)
        return [self.answers count];
    else
        return [self.commentsController numberofComments];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        Answer *answer = [self.answers objectAtIndex:indexPath.row];
        return [self.measuringCell heightForCellWithAnswer:answer];
    }
    else{
        Comment *comment = [self.commentsController commentAtRow:indexPath.row];
        return [self.commentMeasuringCell heightForCellWithComment:comment];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) { //answers
        AnswerCell *cell = (AnswerCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AnswerCell class]) forIndexPath:indexPath];
        
        Answer *answer = [self.answers objectAtIndex:indexPath.row];
        cell.answer = answer;
        
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
    if (indexPath.section == 0) {
        Answer *answer = [self.answers objectAtIndex:indexPath.row];
        if (answer.isOpenForBetting) {
            [self performSegueWithIdentifier:@"ShowBetCreation" sender:answer];
        }
    }
    else if(indexPath.section == 1){ //comments
        Comment *comment = [self.commentsController commentAtRow:indexPath.row];
        if (self.membership.isAdmin || [comment.userId isEqualToNumber:[User currentUser].remoteId]) {
            [self performSegueWithIdentifier:@"ShowCommentForm" sender:comment];
        }
    }
}

@end
