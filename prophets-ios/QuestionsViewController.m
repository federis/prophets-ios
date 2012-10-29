//
//  QuestionsViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/23/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <RestKit/RestKit.h>

#import "QuestionsViewController.h"
#import "UIBarButtonItem+Additions.h"
#import "QuestionCell.h"
#import "User.h"
#import "League.h"
#import "Question.h"
#import "Utilities.h"

@interface QuestionsViewController ()

@end

@implementation QuestionsViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //self.showsPullToRefresh = YES;
    
    [self setupHeaderView];
    
    self.navigationItem.leftItemsSupplementBackButton = YES;
    UIBarButtonItem * item = [UIBarButtonItem homeButtonItemWithTarget:self action:@selector(homeTouched)];
    
    self.navigationItem.leftBarButtonItems = @[item];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"QuestionCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"QuestionCell"];
    
    self.measuringCell = [self.tableView dequeueReusableCellWithIdentifier:@"QuestionCell"];
    
    NSURL *url = [[RKObjectManager sharedManager].router URLForRelationship:@"questions" ofObject:self.league method:RKRequestMethodGET];
    self.fetchRequest = RKFetchRequestFromBlocksWithURL([RKObjectManager sharedManager].fetchRequestBlocks, url);
    self.managedObjectContext = [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
    
    [[RKObjectManager sharedManager] getObjectsAtPathForRelationship:@"questions" ofObject:self.league parameters:nil
     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
         DLog(@"Result is %@", mappingResult);
     }
     failure:^(RKObjectRequestOperation *operation, NSError *error){
         DLog(@"Error is %@", error);
     }];
}

-(void)setupHeaderView{
    self.memberCountLabel.text = [NSString stringWithFormat:@"%@ %@", self.league.membershipsCount,
                                  [Utilities pluralize:self.league.membershipsCount
                                              singular:@"member"
                                                plural:@"members"]];
    
    self.questionCountLabel.text = [NSString stringWithFormat:@"%@ %@", self.league.questionsCount,
                                    [Utilities pluralize:self.league.questionsCount
                                                singular:@"question"
                                                  plural:@"questions"]];
    
    self.headerBackgroundView.layer.cornerRadius = 5.0;
    
    CGFloat leagueNameHeight = [Utilities heightForString:self.league.name
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
    
    self.leagueNameLabel.text = self.league.name;
}


-(void)homeTouched{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    /*
    if([segue.identifier isEqualToString:@"ShowLeague"] && [sender isKindOfClass:[Membership class]]) {
        Membership *membership = (Membership *)sender;
        LeagueTabBarController *leagueTBC = (LeagueTabBarController *)[segue destinationViewController];
        leagueTBC.league = membership.league;
    }
     */
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
 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*Membership *membership = (Membership *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"ShowLeague" sender:membership];*/
}

@end
