//
//  BetViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/3/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <SVProgressHUD.h>

#import "CreateBetViewController.h"
#import "CreateBetView.h"
#import "LeaguePerformanceView.h"
#import "UIColor+Additions.h"
#import "Utilities.h"
#import "Answer.h"
#import "Membership.h"
#import "Question.h"
#import "Bet.h"

@interface CreateBetViewController ()

@end

@implementation CreateBetViewController

- (void)viewDidLoad{
    [super viewDidLoad];
	
    LeaguePerformanceView *performanceView = [[LeaguePerformanceView alloc] init];
    [performanceView setMembership:self.membership];
    self.tableView.tableHeaderView = performanceView;
    
    Bet *bet = (Bet *)[self.scratchContext insertNewObjectForEntityForName:@"Bet"];
    bet.answerId = self.answer.remoteId;
    bet.membershipId = self.membership.remoteId;
    
    self.createBetView = [[CreateBetView alloc] initWithBet:bet inAnswer:self.answer forMembership:self.membership];
    self.createBetView.frame = SameSizeRectAt(1, 6, self.createBetView.frame);
    
    //CGRectMake(1, 6, 283, [CreateBetView heightForViewWithAnswer:self.answer])

    //bet.membership = self.membership;
    //bet.answer = self.answer;

    
    [self.createBetView.submitBetButton addTarget:self action:@selector(submitBetTouched)
                                 forControlEvents:UIControlEventTouchUpInside];
}

-(CGFloat)heightForQuestionContent{
    return [Utilities heightForString:self.answer.question.content
                             withFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:15]
                                width:300];
}

-(void)submitBetTouched{
    Bet *bet = self.createBetView.bet;
    
    [[RKObjectManager sharedManager] postObject:bet path:nil parameters:nil
    success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"Bet created!"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    failure:^(RKObjectRequestOperation *operation, NSError *error){
        [SVProgressHUD dismiss];
        ErrorCollection *errors = [[[error userInfo] objectForKey:RKObjectMapperErrorObjectsKey] lastObject];
        [SVProgressHUD showErrorWithStatus:[errors messagesString]];
    }];
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
    
    questionContentLabel.text = self.answer.question.content;
    questionContentLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:15];
    questionContentLabel.backgroundColor = [UIColor clearColor];
    questionContentLabel.textColor = [UIColor creamColor];
    questionContentLabel.numberOfLines = 0;
    questionContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [v addSubview:questionContentLabel];
    return v;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [CreateBetView heightForViewWithAnswer:self.answer] + 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BlankCell" forIndexPath:indexPath];
    [cell.contentView addSubview:self.createBetView];
    
    return cell;
}

@end
