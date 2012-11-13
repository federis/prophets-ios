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
    return [Utilities heightForString:self.question.content
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
        
        FFLabel *questionContentLabel = [[FFLabel alloc] initWithFrame:CGRectMake(10, 5, 300, [self heightForQuestionContent])];
        questionContentLabel.text = self.question.content;
        
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

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1 && [self.commentsController numberofComments] == 0) {
        return 60;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1 && [self.commentsController numberofComments] == 0) {
        FFLabel *emptyCommentsLabel = [[FFLabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        
        emptyCommentsLabel.isBold = NO;
        emptyCommentsLabel.text = @"No one has commented yet";
        emptyCommentsLabel.textAlignment = NSTextAlignmentCenter;
        
        return emptyCommentsLabel;
    }
    return nil;
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
        [self performSegueWithIdentifier:@"ShowBetCreation" sender:answer];
    }
}

@end
