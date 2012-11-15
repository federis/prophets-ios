//
//  EditAnswersViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/14/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "EditAnswersViewController.h"
#import "FFTableFooterButtonView.h"
#import "EditAnswerCell.h"
#import "Question.h"
#import "Answer.h"
#import "NSDecimalNumber+Additions.h"
#import "Utilities.h"

@interface EditAnswersViewController ()

@end

@implementation EditAnswersViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    if ([self.question.answers count] > 0) {
        self.answers = [[self.question.answers allObjects] mutableCopy];
    }
    else{
        Answer *answer1 = [Answer object];
        answer1.initialProbability = [NSDecimalNumber decimalNumberWithString:@"0.5"];
        Answer *answer2 = [Answer object];
        answer2.initialProbability = [NSDecimalNumber decimalNumberWithString:@"0.5"];
        self.answers = [NSMutableArray arrayWithObjects:answer1, answer2, nil];
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EditAnswerCell class]) bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:NSStringFromClass([EditAnswerCell class])];
    
}

-(void)submit{
    
}

-(void)addAnswer{
    Answer *newAnswer = [Answer object];
    if ([self allAnswersHaveSameInitialProbability]) {
        [self.answers addObject:newAnswer];
        [self rebalanceAnswerProbabilities];
    }
    else if([self currentSumOfAnswerInitialProbablities] < 1.0){
        CGFloat val = 1.0 - [self currentSumOfAnswerInitialProbablities];
        newAnswer.initialProbability = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithFloat:val] decimalValue]];
        
        [self.answers addObject:newAnswer];
    }
    else{
        [self.answers addObject:newAnswer];
    }
    
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.answers.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)removeAnswer:(id)sender{
    if (self.answers.count == 2) {
        [Utilities showOkAlertWithTitle:@"Invalid Answer Set"
                                message:@"You must have at least 2 answers in a question"];
        return;
    }
    
    UIView *v = [[(UIButton *)sender superview] superview];
    if ([v isKindOfClass:[EditAnswerCell class]]) {
        EditAnswerCell *cell = (EditAnswerCell *)v;
        [self.answers removeObject:cell.answer];
        NSArray *indexPaths = @[[self.tableView indexPathForCell:cell]];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        
        if ([self allAnswersHaveSameInitialProbability]) {
            [self rebalanceAnswerProbabilities];
        }
    }
}

-(void)rebalanceAnswerProbabilities{
    NSDecimalNumber *initalProb = [NSDecimalNumber decimalNumberWithTwoDecimalPlacesFromFloat:(1.0/self.answers.count)];
    
    for (Answer *answer in self.answers) {
        answer.initialProbability = initalProb;
    }
}

-(CGFloat)currentSumOfAnswerInitialProbablities{
    NSDecimalNumber *sum = [NSDecimalNumber decimalNumberWithString:@"0"];
    for (Answer *answer in self.answers) {
        sum = [sum decimalNumberByAdding:answer.initialProbability];
    }
    return [sum floatValue];
}

-(BOOL)allAnswersHaveSameInitialProbability{
    for (int i=0; i<self.answers.count-1; i++) {
        Answer *answer1 = [self.answers objectAtIndex:i];
        Answer *answer2 = [self.answers objectAtIndex:i+1];
        if (![answer1.initialProbability isEqualToNumber:answer2.initialProbability]) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return self.answers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditAnswerCell *cell = (EditAnswerCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EditAnswerCell class]) forIndexPath:indexPath];
    
    cell.answer = [self.answers objectAtIndex:indexPath.row];
    [cell.removeButton addTarget:self action:@selector(removeAnswer:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    FFTableFooterButtonView *footerView = [FFTableFooterButtonView footerButtonViewForTable:self.tableView withText:@"Submit"];
    [footerView setLeftButtonText:@"Add Another"];
    [footerView.button addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [footerView.leftButton addTarget:self action:@selector(addAnswer) forControlEvents:UIControlEventTouchUpInside];
    return footerView;
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
