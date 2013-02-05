//
//  ManageQuestionsViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 1/30/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import <SVProgressHUD.h>

#import "ManageQuestionsViewController.h"
#import "QuestionFormViewController.h"
#import "JudgeViewController.h"
#import "League.h"
#import "AdminQuestionCell.h"
#import "UIAlertView+Additions.h"

@interface ManageQuestionsViewController ()

@end

@implementation ManageQuestionsViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AdminQuestionCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"AdminQuestionCell"];
    
    self.measuringCell = [self.tableView dequeueReusableCellWithIdentifier:@"AdminQuestionCell"];
    
    NSURL *url = nil;
    
    if (self.scope == FFQuestionUnapproved) {
        url = [[RKObjectManager sharedManager].router URLForRouteNamed:@"unapproved_questions" method:nil object:self.league];
    }
    else if (self.scope == FFQuestionPendingJudgement){
        url = [[RKObjectManager sharedManager].router URLForRouteNamed:@"pending_judgement_questions" method:nil object:self.league];
    }
    else if (self.scope == FFQuestionComplete){
        url = [[RKObjectManager sharedManager].router URLForRouteNamed:@"complete_questions" method:nil object:self.league];
    }
    else{
        url = [[RKObjectManager sharedManager].router URLForRelationship:@"questions" ofObject:self.league method:RKRequestMethodGET];
    }
    
    self.fetchRequest = [RKArrayOfFetchRequestFromBlocksWithURL([RKObjectManager sharedManager].fetchRequestBlocks, url) lastObject];
    self.managedObjectContext = [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
    
    FFLabel *emptyQuestionsLabel = [[FFLabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    
    emptyQuestionsLabel.isBold = NO;
    emptyQuestionsLabel.text = @"No questions found";
    emptyQuestionsLabel.textAlignment = NSTextAlignmentCenter;
    
    self.emptyContentFooterView = emptyQuestionsLabel;
    
    [[RKObjectManager sharedManager] getObjectsAtPath:[url relativeString] parameters:nil
     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
         DLog(@"Result is %@", mappingResult);
     }
     failure:^(RKObjectRequestOperation *operation, NSError *error){
         DLog(@"Error is %@", error);
     }];

}

#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Question *question = (Question *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    return [self.measuringCell heightForCellWithQuestion:question];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AdminQuestionCell *cell = (AdminQuestionCell *)[tableView dequeueReusableCellWithIdentifier:@"AdminQuestionCell" forIndexPath:indexPath];
    
    Question *question = (Question *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.question = question;
    cell.scope = self.scope; //needs to come after question is set, so buttons are placed correctly
    
    [cell.publishButton addTarget:self action:@selector(publishTouched:) forControlEvents:UIControlEventTouchUpInside];
    [cell.editButton addTarget:self action:@selector(editTouched:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteButton addTarget:self action:@selector(deleteTouched:) forControlEvents:UIControlEventTouchUpInside];
    [cell.judgeButton addTarget:self action:@selector(judgeTouched:) forControlEvents:UIControlEventTouchUpInside];
    [cell.viewButton addTarget:self action:@selector(viewTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}



-(IBAction)publishTouched:(id)sender{
    Question *question = ((AdminQuestionCell *)[[sender superview] superview]).question;
    
    NSURL *url = [[RKObjectManager sharedManager].router URLForRouteNamed:@"approve_question" method:nil object:question];
    
    [SVProgressHUD showWithStatus:@"Publishing question" maskType:SVProgressHUDMaskTypeGradient];
    
    [[RKObjectManager sharedManager] putObject:question path:[url relativeString] parameters:nil
       success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
           [SVProgressHUD dismiss];
           [SVProgressHUD showSuccessWithStatus:@"Question published"];
       }
       failure:^(RKObjectRequestOperation *operation, NSError *error){
           [SVProgressHUD dismiss];
           
           ErrorCollection *errors = [[[error userInfo] objectForKey:RKObjectMapperErrorObjectsKey] lastObject];
           [SVProgressHUD showErrorWithStatus:[errors messagesString]];
           
           DLog(@"%@", [error description]);
       }];
}

-(IBAction)editTouched:(id)sender{
    Question *question = ((AdminQuestionCell *)[[sender superview] superview]).question;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard_iPhone" bundle: nil];
    QuestionFormViewController *questionVC = [storyboard instantiateViewControllerWithIdentifier:@"QuestionFormViewController"];
    
    questionVC.question = question;
    [self.navigationController pushViewController:questionVC animated:YES];
}

-(IBAction)deleteTouched:(id)sender{
    Question *question = ((AdminQuestionCell *)[[sender superview] superview]).question;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Question" message:@"Are you sure you want to delete this question?"
       completionBlock:^(NSUInteger buttonIndex, UIAlertView *alert){
           [SVProgressHUD showWithStatus:@"Deleting question" maskType:SVProgressHUDMaskTypeGradient];
           
           [[RKObjectManager sharedManager] deleteObject:question path:nil parameters:nil
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
     cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    
    [alert show];
}

-(IBAction)judgeTouched:(id)sender{
    Question *question = ((AdminQuestionCell *)[[sender superview] superview]).question;
    [self performSegueWithIdentifier:@"ShowJudge" sender:question];
}

-(IBAction)viewTouched:(id)sender{
    Question *question = ((AdminQuestionCell *)[[sender superview] superview]).question;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"ShowJudge"]) {
        JudgeViewController *judgeVC = (JudgeViewController *)[segue destinationViewController];
        judgeVC.question = sender;
    }
}


@end
