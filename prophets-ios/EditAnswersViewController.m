//
//  EditAnswersViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/14/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <SVProgressHUD.h>

#import "EditAnswersViewController.h"
#import "ReviewQuestionViewController.h"
#import "FFTableFooterButtonView.h"
#import "EditAnswerCell.h"
#import "Question.h"
#import "Answer.h"
#import "NSDecimalNumber+Additions.h"
#import "Utilities.h"
#import "UIView+Additions.h"
#import "UIColor+Additions.h"

@interface EditAnswersViewController ()

@end

@implementation EditAnswersViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    if ([self.question.answers count] > 0) {
        self.answers = [[self.question.answers allObjects] mutableCopy];
        
        for (Answer *answer in self.answers) {
            [answer addObserver:self forKeyPath:@"initialProbability" options:NSKeyValueObservingOptionNew context:nil];
        }
    }
    else{
        Answer *answer1 = [self newAnswer];
        answer1.initialProbability = [NSDecimalNumber decimalNumberWithString:@"0.5"];
        
        Answer *answer2 = [self newAnswer];
        answer2.initialProbability = [NSDecimalNumber decimalNumberWithString:@"0.5"];
        
        self.answers = [NSMutableArray arrayWithObjects:answer1, answer2, nil];
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EditAnswerCell class]) bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:NSStringFromClass([EditAnswerCell class])];
    
    self.probabilitiesSum = [[FFLabel alloc] initWithFrame:CGRectMake(0, 0, 55, 40)];
    self.probabilitiesSum.fontSize = 18.0f;
    self.probabilitiesSum.textAlignment = NSTextAlignmentRight;
    [self updateProbabilitiesSumLabel];
    
    UIBarButtonItem *probSumItem = [[UIBarButtonItem alloc] initWithCustomView:self.probabilitiesSum];
    self.navigationItem.rightBarButtonItem = probSumItem;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"initialProbability"]) {
        [self updateProbabilitiesSumLabel];
    }
}


-(void)updateProbabilitiesSumLabel{
    CGFloat sum = [self currentSumOfAnswerInitialProbablities] * 100;
    self.probabilitiesSum.text = [NSString stringWithFormat:@"%.0f%%", sum];
    if (sum == 100.0) {
        self.probabilitiesSum.textColor = [UIColor ffGreenColor];
    }
    else{
        self.probabilitiesSum.textColor = [UIColor ffRedColor];
    }
}

-(Answer *)newAnswer{
    NSManagedObjectContext *privateContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    [privateContext performBlockAndWait:^{
        privateContext.parentContext = [RKObjectManager sharedManager].managedObjectStore.persistentStoreManagedObjectContext;
        privateContext.mergePolicy  = NSMergeByPropertyStoreTrumpMergePolicy;
    }];
    
    [self.tempContexts addObject:privateContext];
    
    Answer *answer = (Answer *)[privateContext insertNewObjectForEntityForName:@"Answer"];
    answer.questionId = self.question.remoteId;
    
    [answer addObserver:self forKeyPath:@"initialProbability" options:NSKeyValueObservingOptionNew context:nil];
    
    return answer;
}

-(NSMutableArray *)tempContexts{
    if (_tempContexts) return _tempContexts;
    
    _tempContexts = [NSMutableArray array];
    return _tempContexts;
}

-(void)submit{
    for (Answer *answer in self.answers) {
        if (!answer.content || [answer.content isEqualToString:@""]) {
            [Utilities showOkAlertWithTitle:@"Invalid Answer"
                                    message:@"Answer text cannot be blank"];
            return;
        }
    }
    
    if ([self currentSumOfAnswerInitialProbablities] != 1.0) {
        [Utilities showOkAlertWithTitle:@"Invalid Probabilities"
                                message:@"The answer probabilities must add up to 1.0"];
        return;
    }
    
    //delete any answers from the question that the user deleted from the screen
    NSMutableSet *answersToDelete = [[NSMutableSet alloc] init];
    for (Answer *answer in self.question.answers) {
        if (![self.answers containsObject:answer]) {
            [answersToDelete addObject:answer];
        }
    }
    
    [SVProgressHUD showWithStatus:@"Saving answers" maskType:SVProgressHUDMaskTypeGradient];
    
    NSMutableArray *requests = [NSMutableArray array];
    for (Answer *answer in self.answers) {
        RKRequestMethod method = answer.remoteId ? RKRequestMethodPUT : RKRequestMethodPOST;
        
        RKManagedObjectRequestOperation *request = [[RKObjectManager sharedManager] appropriateObjectRequestOperationWithObject:answer method:method path:nil parameters:nil];
        
        [requests addObject:request];
    }
    
    for (Answer *answer in answersToDelete) {
        RKManagedObjectRequestOperation *request = [[RKObjectManager sharedManager] appropriateObjectRequestOperationWithObject:answer method:RKRequestMethodDELETE path:nil parameters:nil];
        
        [requests addObject:request];
    }
    
    [[RKObjectManager sharedManager] enqueueBatchOfObjectRequestOperations:requests
      progress:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
          
      } completion:^ (NSArray *operations) {
          
          [SVProgressHUD dismiss];
          
          for (RKManagedObjectRequestOperation *operation in operations) {
              if (operation.error) {
                  DLog(@"%@", operation.error);
                  
                  [SVProgressHUD showErrorWithStatus:[operation.error description]];
                  return;
              }
          }
          
          [SVProgressHUD showSuccessWithStatus:@"Answers saved"];
          
          //send them to review
          [self performSegueWithIdentifier:@"ShowReviewQuestion" sender:self.question];
      }];
    
}

-(void)addAnswer{
    Answer *newAnswer = [self newAnswer];
    [self.answers addObject:newAnswer];
    
    if ([self allAnswersHaveSameInitialProbability]) {
        [self rebalanceAnswerProbabilities];
    }
    else if([self currentSumOfAnswerInitialProbablities] < 1.0){
        CGFloat val = 1.0 - [self currentSumOfAnswerInitialProbablities];
        newAnswer.initialProbability = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithFloat:val] decimalValue]];
    }
    else{
        newAnswer.initialProbability = [NSDecimalNumber decimalNumberWithString:@"0"];
    }
    
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.answers.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)removeAnswer:(id)sender{
    if (self.answers.count == 2) {
        [Utilities showOkAlertWithTitle:@"Invalid Answer Set"
                                message:@"You must have at least 2 answers in a question"];
        return;
    }
    
    UITableViewCell *parentCell = [(UIButton *)sender findParentTableViewCell];
    if ([parentCell isKindOfClass:[EditAnswerCell class]]) {
        EditAnswerCell *cell = (EditAnswerCell *)parentCell;
        
        [cell.answer removeObserver:self forKeyPath:@"initialProbability"];
        
        [self.answers removeObject:cell.answer];
        [self.tempContexts removeObject:cell.answer.managedObjectContext];
        
        [cell.removeButton removeTarget:self action:@selector(removeAnswer:) forControlEvents:UIControlEventTouchUpInside];
        
        NSArray *indexPaths = @[[self.tableView indexPathForCell:cell]];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        
        if ([self allAnswersHaveSameInitialProbability]) {
            [self rebalanceAnswerProbabilities];
        }
        
        [self updateProbabilitiesSumLabel];
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
        if (answer.initialProbability) {
            sum = [sum decimalNumberByAdding:answer.initialProbability];
        }
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ShowReviewQuestion"] && [sender isKindOfClass:[Question class]]) {
        ReviewQuestionViewController *reviewVC = (ReviewQuestionViewController *)[segue destinationViewController];
        reviewVC.question = (Question *)sender;
    }
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
    FFTableFooterButtonView *footerView = [FFTableFooterButtonView footerButtonViewForTable:self.tableView withText:@"Save"];
    [footerView setLeftButtonText:@"Add Another"];
    [footerView.button addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [footerView.leftButton addTarget:self action:@selector(addAnswer) forControlEvents:UIControlEventTouchUpInside];
    return footerView;
}

-(void)dealloc{
    for (Answer *answer in self.answers) {
        [answer removeObserver:self forKeyPath:@"initialProbability"];
    }
}

@end
