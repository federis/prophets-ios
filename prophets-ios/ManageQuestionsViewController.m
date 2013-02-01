//
//  ManageQuestionsViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 1/30/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import "ManageQuestionsViewController.h"
#import "League.h"
#import "AdminQuestionCell.h"

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
    
    return cell;
}

@end
