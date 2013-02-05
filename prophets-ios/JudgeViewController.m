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
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
    
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
    [self judgeAnswer:answer correct:NO];
}

-(IBAction)correctTouched:(id)sender{
    Answer *answer = ((JudgeAnswerCell *)[[sender superview] superview]).answer;
    
    [self judgeAnswer:answer correct:YES];
}

-(void)judgeAnswer:(Answer *)answer correct:(BOOL)correct{
    NSString *msg = correct ? @"Are you sure you want to mark this answer correct?" : @"Are you sure you want to mark this answer incorrect?";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Judge Answer" message:msg
        completionBlock:^(NSUInteger buttonIndex, UIAlertView *alert){
            NSURL *url = [[RKObjectManager sharedManager].router URLForRouteNamed:@"judge_answer" method:nil object:answer];
            
            [SVProgressHUD showWithStatus:@"Judging answer" maskType:SVProgressHUDMaskTypeGradient];
            
            answer.correct = [NSNumber numberWithBool:correct];
            answer.correctnessKnownAt = [NSDate date];
            
            NSDictionary *params = @{@"answer[correct]": [NSNumber numberWithBool:correct], @"answer[correctness_known_at]" : answer.correctnessKnownAt};
            [[RKObjectManager sharedManager] putObject:nil path:[url relativePath] parameters:params
               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
                   [SVProgressHUD dismiss];
                   [SVProgressHUD showSuccessWithStatus:@"Answer judged"];
                   
                   if (correct) {
                       for (Answer *otherAnswer in answer.question.answers) {
                           if ([answer.remoteId integerValue] != [otherAnswer.remoteId integerValue]) {
                               otherAnswer.isCorrect = NO;
                               otherAnswer.correctnessKnownAt = answer.correctnessKnownAt;
                               otherAnswer.judgedAt = answer.judgedAt;
                           }
                       }
                   }
                   
                   if (answer.question.allAnswersJudged) {
                       answer.question.completedAt = answer.judgedAt;
                   }
                   
                   if(self.managedObjectContext.hasChanges){
                       [self.managedObjectContext save:nil];
                   }
               }
               failure:^(RKObjectRequestOperation *operation, NSError *error){
                   [SVProgressHUD dismiss];
                   
                   ErrorCollection *errors = [[[error userInfo] objectForKey:RKObjectMapperErrorObjectsKey] lastObject];
                   [SVProgressHUD showErrorWithStatus:[errors messagesString]];
                   
                   DLog(@"%@", [error description]);
               }];
        }
      cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    
    [alert show];
}

@end
