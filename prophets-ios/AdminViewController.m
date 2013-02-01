//
//  AdminViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 1/30/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import "AdminViewController.h"
#import "LeagueFormViewController.h"
#import "FFBaseCell.h"
#import "UIColor+Additions.h"
#import "ManageQuestionsViewController.h"

@interface AdminViewController ()

@end

@implementation AdminViewController


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FFBaseCell *cell = [[FFBaseCell alloc] init];
    cell.backgroundColor = [UIColor creamColor];
    FFLabel *label = [[FFLabel alloc] initWithFrame:CGRectMake(20, 7, 270, 30)];
    label.textColor = [UIColor blackColor];
    
    if(indexPath.row == 0){
        label.text = @"Questions Awaiting Approval";
    }
    else if (indexPath.row == 1){
        label.text = @"Questions Currently Running";
    }
    else if (indexPath.row == 2){
        label.text = @"Questions Awaiting Judgement";
    }
    else if (indexPath.row == 3){
        label.text = @"Completed Questions";
    }
    else if (indexPath.row == 4){
        label.text = @"Users";
    }
    else{
        label.text = @"League";
    }
    
    [cell addSubview:label];
    cell.showsAccessoryView = YES;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(indexPath.row == 0){
        [self performSegueWithIdentifier:@"ShowManageQuestions" sender:[NSNumber numberWithUnsignedInteger:FFQuestionUnapproved]];
    }
    else if (indexPath.row == 1){
        [self performSegueWithIdentifier:@"ShowManageQuestions" sender:[NSNumber numberWithUnsignedInteger:FFQuestionCurrentlyRunning]];
    }
    else if (indexPath.row == 2){
        [self performSegueWithIdentifier:@"ShowManageQuestions" sender:[NSNumber numberWithUnsignedInteger:FFQuestionPendingJudgement]];
    }
    else if (indexPath.row == 3){
        [self performSegueWithIdentifier:@"ShowManageQuestions" sender:[NSNumber numberWithUnsignedInteger:FFQuestionComplete]];
    }
    else if (indexPath.row == 4){
        [self performSegueWithIdentifier:@"ShowManageUsers" sender:nil];
    }
    else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard_iPhone" bundle: nil];
        LeagueFormViewController *leagueVC = [storyboard instantiateViewControllerWithIdentifier:@"LeagueFormViewController"];
        
        leagueVC.league = self.league;
        [self.navigationController pushViewController:leagueVC animated:YES];
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
     if([segue.identifier isEqualToString:@"ShowManageQuestions"]) {
         ManageQuestionsViewController *questionsVC = (ManageQuestionsViewController *)[segue destinationViewController];
         questionsVC.scope = [(NSNumber *)sender unsignedIntegerValue];;
     }
    
    if ([segue.destinationViewController respondsToSelector:@selector(setLeague:)]) {
        [segue.destinationViewController performSelector:@selector(setLeague:) withObject:self.league];
    }
}

@end
