//
//  QuestionsViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/23/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <RestKit/RestKit.h>

#import "QuestionsViewController.h"
#import "AnswersViewController.h"
#import "QuestionFormViewController.h"
#import "UIBarButtonItem+Additions.h"
#import "UIColor+Additions.h"
#import "FFLabel.h"
#import "ClearButton.h"
#import "QuestionCell.h"
#import "User.h"
#import "Membership.h"
#import "League.h"
#import "Question.h"
#import "Utilities.h"
#import "FFApplicationConstants.h"

@interface QuestionsViewController ()

@end

@implementation QuestionsViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.showsPullToRefresh = YES;
    
    [self setupHeaderView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"QuestionCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"QuestionCell"];
    
    self.measuringCell = [self.tableView dequeueReusableCellWithIdentifier:@"QuestionCell"];
    
    NSURL *url = [[RKObjectManager sharedManager].router URLForRelationship:@"questions" ofObject:self.membership.league method:RKRequestMethodGET];
    
    self.fetchRequest = [RKArrayOfFetchRequestFromBlocksWithURL([RKObjectManager sharedManager].fetchRequestBlocks, url) lastObject];
    self.managedObjectContext = [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
    
    FFLabel *emptyQuestionsLabel = [[FFLabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    
    emptyQuestionsLabel.isBold = NO;
    emptyQuestionsLabel.text = @"No questions have been created yet";
    emptyQuestionsLabel.textAlignment = NSTextAlignmentCenter;
    
    self.emptyContentFooterView = emptyQuestionsLabel;
    
    self.reloading = YES;
    [self loadData];
}

-(void)loadData{
    [[RKObjectManager sharedManager] getObjectsAtPathForRelationship:@"questions" ofObject:self.membership.league parameters:nil
     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
         DLog(@"Result is %@", mappingResult);
         self.reloading = NO;
     }
     failure:^(RKObjectRequestOperation *operation, NSError *error){
         DLog(@"Error is %@", error);
         self.reloading = NO;
     }];
}

-(void)setupHeaderView{
    self.memberCountLabel.text = [NSString stringWithFormat:@"%@ %@", self.membership.league.membershipsCount,
                                  [Utilities pluralize:self.membership.league.membershipsCount
                                              singular:@"member"
                                                plural:@"members"]];
    
    self.questionCountLabel.text = [NSString stringWithFormat:@"%@ %@", self.membership.league.questionsCount,
                                    [Utilities pluralize:self.membership.league.questionsCount
                                                singular:@"question"
                                                  plural:@"questions"]];
    
    self.headerBackgroundView.layer.cornerRadius = 5.0;
    
    CGFloat leagueNameHeight = [Utilities heightForString:self.membership.league.name
                                                 withFont:self.leagueNameLabel.font
                                                    width:self.leagueNameLabel.frame.size.width];
    
    self.headerBackgroundView.frame = CGRectMake(self.headerBackgroundView.frame.origin.x,
                                                 self.headerBackgroundView.frame.origin.y,
                                                 self.headerBackgroundView.frame.size.width,
                                                 leagueNameHeight + 50);
    
    self.leagueNameLabel.frame = CGRectMake(self.leagueNameLabel.frame.origin.x,
                                            self.leagueNameLabel.frame.origin.y,
                                            self.leagueNameLabel.frame.size.width,
                                            leagueNameHeight);
    
    self.leagueNameLabel.text = self.membership.league.name;
}


-(void)homeTouched{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)addQuestionTouched{
    [self performSegueWithIdentifier:@"ShowQuestionForm" sender:nil];
}

-(void)inviteMemberTouched{
    MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
    mailVC.mailComposeDelegate = self;
    [mailVC setSubject:@"Join this league on 55Prophets"];
    NSString *body = [NSString stringWithFormat:@"<p>Hey there,</p> \
                      <p>I joined the league \"%@\" on 55Prophets, and I think you should join too. You can join by opening this email on your phone and touching \
                         <a href='%@://leagues/%@/join'>here</a>.</p> \
                      <p>If you don't have the 55Prophets app yet, you can download it on the <a href='https://itunes.apple.com/us/app/55prophets/id622424094?ls=1&mt=8'>app store</a>.</p> \
                      <p>Cheers.</p>", self.membership.league.name, FFURLScheme, self.membership.league.remoteId];
    [mailVC setMessageBody:body isHTML:YES];
    
    [self presentModalViewController:mailVC animated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    [self dismissViewControllerAnimated:YES completion:^{}];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"ShowAnswers"] && [sender isKindOfClass:[Question class]]) {
        Question *question = (Question *)sender;
        AnswersViewController *answersVC = (AnswersViewController *)[segue destinationViewController];
        answersVC.question = question;
        answersVC.membership = self.membership;
    }
    else if([segue.identifier isEqualToString:@"ShowQuestionForm"]){
        QuestionFormViewController *formVC = (QuestionFormViewController *)[segue destinationViewController];
        formVC.league = self.membership.league;
    }
}

#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Question *question = (Question *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    return [self.measuringCell heightForCellWithQuestion:question];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QuestionCell *cell = (QuestionCell *)[tableView dequeueReusableCellWithIdentifier:@"QuestionCell" forIndexPath:indexPath];
    
    Question *question = (Question *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.question = question;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
    
    ClearButton *addQuestionButton = [[ClearButton alloc] init];
    if (self.membership.isAdmin) {
        addQuestionButton.frame = CGRectMake(175, 0, 120, 30);
        [addQuestionButton setTitle:@"Add Question" forState:UIControlStateNormal];
    }
    else{
        addQuestionButton.frame = CGRectMake(165, 0, 132, 30);
        [addQuestionButton setTitle:@"Suggest Question" forState:UIControlStateNormal];
    }
    [addQuestionButton addTarget:self action:@selector(addQuestionTouched) forControlEvents:UIControlEventTouchUpInside];
    
    ClearButton *inviteMemberButton = [[ClearButton alloc] initWithFrame:CGRectMake(10, 0, 145, 30)];
    [inviteMemberButton setTitle:@"Invite New Member" forState:UIControlStateNormal];
    [inviteMemberButton addTarget:self action:@selector(inviteMemberTouched) forControlEvents:UIControlEventTouchUpInside];
    
    [v addSubview:addQuestionButton];
    [v addSubview:inviteMemberButton];
    return v;
}
 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Question *question = (Question *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"ShowAnswers" sender:question];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
