//
//  ReviewQuestionViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/16/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <SVProgressHUD.h>

#import "ReviewQuestionViewController.h"
#import "LeagueTabBarController.h"
#import "Question.h"
#import "AnswerCell.h"
#import "User.h"
#import "Membership.h"
#import "League.h"

@interface ReviewQuestionViewController ()

@end

@implementation ReviewQuestionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *answerCellName = NSStringFromClass([AnswerCell class]);
    [self.tableView registerNib:[UINib nibWithNibName:answerCellName bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:answerCellName];
    
    self.measuringCell = [self.tableView dequeueReusableCellWithIdentifier:answerCellName];
	
    self.answers = [self.question.answers allObjects];
}

-(void)approve{
    NSURL *url = [[RKObjectManager sharedManager].router URLForRouteNamed:@"approve_question" method:nil object:self.question];
    
    [SVProgressHUD showWithStatus:@"Publishing question" maskType:SVProgressHUDMaskTypeGradient];
    
    [[RKObjectManager sharedManager] putObject:self.question path:[url relativeString] parameters:nil
       success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
           [SVProgressHUD dismiss];
           [SVProgressHUD showSuccessWithStatus:@"Question published"];
           
           [self returnToLeague];
       }
       failure:^(RKObjectRequestOperation *operation, NSError *error){
           [SVProgressHUD dismiss];
           
           ErrorCollection *errors = [[[error userInfo] objectForKey:RKObjectMapperErrorObjectsKey] lastObject];
           [SVProgressHUD showErrorWithStatus:[errors messagesString]];
           
           DLog(@"%@", [error description]);
       }];
}

-(void)returnToLeague{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if([controller isKindOfClass:[LeagueTabBarController class]]){
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"ReviewQuestionViewController should always exist as a child of a LeagueTabBarController"
                                 userInfo:nil];
}

-(CGFloat)heightForQuestionContent{
    return [Utilities heightForString:self.question.content
                             withFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:15]
                                width:290];
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [self heightForQuestionContent] + 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [self heightForQuestionContent] + 10)];
    
    FFLabel *questionContentLabel = [[FFLabel alloc] initWithFrame:CGRectMake(10, 5, 290, [self heightForQuestionContent])];
    questionContentLabel.text = self.question.content;
    
    FFLabel *closeOfBettingLabel = [[FFLabel alloc] initWithFrame:CGRectMake(10, [self heightForQuestionContent] + 10, 320, 20)];
    closeOfBettingLabel.isBold = NO;
    closeOfBettingLabel.fontSize = 12;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mma zzz MMM dd,yyyy";
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    
    closeOfBettingLabel.text = [NSString stringWithFormat:@"Close of Betting: %@", [dateFormatter stringFromDate:self.question.bettingClosesAt]];
    
    [v addSubview:questionContentLabel];
    [v addSubview:closeOfBettingLabel];
    return v;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.answers.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Answer *answer = [self.answers objectAtIndex:indexPath.row];
    return [self.measuringCell heightForCellWithAnswer:answer];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AnswerCell *cell = (AnswerCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AnswerCell class]) forIndexPath:indexPath];
    
    Answer *answer = [self.answers objectAtIndex:indexPath.row];
    cell.answer = answer;
    cell.showsAccessoryView = NO;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    FFTableFooterButtonView *footerView = nil;
    
    Membership *membership = [[User currentUser] membershipInLeague:self.question.league.remoteId];
    if (membership.isAdmin) {
        footerView = [FFTableFooterButtonView footerButtonViewForTable:self.tableView withText:@"Publish"];
        [footerView.button addTarget:self action:@selector(approve) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        footerView = [FFTableFooterButtonView footerButtonViewForTable:self.tableView withText:@"Return to League"];
        [footerView.button addTarget:self action:@selector(returnToLeague) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return footerView;
}


@end
