//
//  JudgeViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 2/4/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import <SVProgressHUD.h>

#import "JudgeViewController.h"
#import "JudgeAnswerCell.h"
#import "Question.h"
#import "Answer.h"
#import "UIAlertView+Additions.h"
#import "CorrectnessDateViewController.h"

@interface JudgeViewController ()

@end

@implementation JudgeViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JudgeAnswerCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"JudgeAnswerCell"];
    
    self.measuringCell = [self.tableView dequeueReusableCellWithIdentifier:@"JudgeAnswerCell"];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Answer"];
    request.predicate = [NSPredicate predicateWithFormat:@"questionId = %@", self.question.remoteId];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO]];
    
    self.fetchRequest = request;
    self.managedObjectContext = [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
    
    FFLabel *emptyAnswersLabel = [[FFLabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    
    emptyAnswersLabel.isBold = NO;
    emptyAnswersLabel.text = @"No answers have been created yet";
    emptyAnswersLabel.textAlignment = NSTextAlignmentCenter;
    
    self.emptyContentFooterView = emptyAnswersLabel;
}

#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Answer *answer = (Answer *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    return [self.measuringCell heightForCellWithAnswer:answer];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JudgeAnswerCell *cell = (JudgeAnswerCell *)[tableView dequeueReusableCellWithIdentifier:@"JudgeAnswerCell" forIndexPath:indexPath];
    
    Answer *answer = (Answer *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.answer = answer;
    
    [cell.incorrectButton addTarget:self action:@selector(incorrectTouched:) forControlEvents:UIControlEventTouchUpInside];
    [cell.correctButton addTarget:self action:@selector(correctTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}


-(IBAction)incorrectTouched:(id)sender{
    Answer *answer = ((JudgeAnswerCell *)[[sender superview] superview]).answer;
    answer.correct = [NSNumber numberWithBool:NO];
    [self performSegueWithIdentifier:@"ShowCorrectnessDate" sender:answer];
}

-(IBAction)correctTouched:(id)sender{
    Answer *answer = ((JudgeAnswerCell *)[[sender superview] superview]).answer;
    answer.correct = [NSNumber numberWithBool:YES];
    [self performSegueWithIdentifier:@"ShowCorrectnessDate" sender:answer];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"ShowCorrectnessDate"]) {
        Answer *answer = (Answer *)sender;
        CorrectnessDateViewController *correctnessVC = (CorrectnessDateViewController *)[segue destinationViewController];
        correctnessVC.answer = answer;
    }
}

@end
