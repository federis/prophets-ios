//
//  AnswersViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/3/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "AnswersViewController.h"
#import "LeaguePerformanceView.h"
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
    
    self.measuringCell = [self.tableView dequeueReusableCellWithIdentifier:answerCellName];
    
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

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return [self heightForQuestionContent] + 10;
    }
    
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section != 0) return nil;
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [self heightForQuestionContent] + 10)];
    UILabel *questionContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, [self heightForQuestionContent])];
    
    questionContentLabel.text = self.question.content;
    questionContentLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:15];
    questionContentLabel.backgroundColor = [UIColor clearColor];
    questionContentLabel.textColor = [UIColor creamColor];
    questionContentLabel.numberOfLines = 0;
    questionContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [v addSubview:questionContentLabel];
    return v;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2; //answers and comments
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0)
        return [self.answers count];
    else
        return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Answer *answer = [self.answers objectAtIndex:indexPath.row];
    return [self.measuringCell heightForCellWithAnswer:answer];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) { //answers
        AnswerCell *cell = (AnswerCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AnswerCell class]) forIndexPath:indexPath];
        
        Answer *answer = [self.answers objectAtIndex:indexPath.row];
        cell.answer = answer;
        
        return cell;
    }
    else{ //comments
        return nil;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
