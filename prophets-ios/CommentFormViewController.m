//
//  CommentFormViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/12/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <SVProgressHUD.h>

#import "CommentFormViewController.h"
#import "Comment.h"
#import "Question.h"
#import "League.h"
#import "Bet.h"
#import "RoundedClearBar.h"

@interface CommentFormViewController ()

@end

@implementation CommentFormViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    RoundedClearBar *bar = nil;
    if (self.form.object) { //then we were given an existing comment
        bar = [[RoundedClearBar alloc] initWithTitle:@"Edit Comment"];
    }
    else{
        bar = [[RoundedClearBar alloc] initWithTitle:@"Create Comment"];
    }
    
    [bar.leftButton addTarget:self action:@selector(cancelTouched) forControlEvents:UIControlEventTouchUpInside];
    self.fixedHeaderView = bar;
}

-(void)cancelTouched{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)prepareForm{
    Comment *comment = self.existingComment;
    if (!comment) {
        //Comments should be in either a league or a question, but not both
        NSAssert(self.question || self.league || self.bet, @"You must provide a league, bet, or question for the comment");
        NSAssert(!(self.question && self.league), @"You cannot provide both a league and question for the comment");
        
        comment = (Comment *)[self.scratchContext insertNewObjectForEntityForName:@"Comment"];
        if (self.question) {
            comment.questionId = self.question.remoteId;
        }
        else if(self.bet){
            comment.betId = self.bet.remoteId;
        }
        else if(self.league){
            comment.leagueId = self.league.remoteId;
        }
    }
    
    FFFormTextViewField *commentField = [FFFormTextViewField formFieldWithAttributeName:@"comment"];
    
    self.form = [FFForm formForObject:comment withFields:@[commentField]];
    
    self.submitButtonText = @"Submit";
}

-(void)submit{
    [SVProgressHUD showWithStatus:@"Submitting comment" maskType:SVProgressHUDMaskTypeGradient];
    
    Comment *comment = (Comment *)self.form.object;
    
    if (comment.remoteId) {
        [[RKObjectManager sharedManager] putObject:comment path:[comment urlPath] parameters:nil
            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
                [SVProgressHUD dismiss];
                [SVProgressHUD showSuccessWithStatus:@"Comment updated"];
                
                [self dismissViewControllerAnimated:YES completion:^{}];
            }
            failure:^(RKObjectRequestOperation *operation, NSError *error){
                [SVProgressHUD dismiss];
                
                ErrorCollection *errors = [[[error userInfo] objectForKey:RKObjectMapperErrorObjectsKey] lastObject];
                [SVProgressHUD showErrorWithStatus:[errors messagesString]];
                
                DLog(@"%@", [error description]);
            }];
    }
    else{
        [[RKObjectManager sharedManager] postObject:comment path:[comment urlPath] parameters:nil
            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
                [SVProgressHUD dismiss];
                [SVProgressHUD showSuccessWithStatus:@"Comment created"];
                
                [self dismissViewControllerAnimated:YES completion:^{}];
            }
            failure:^(RKObjectRequestOperation *operation, NSError *error){
                [SVProgressHUD dismiss];
                
                ErrorCollection *errors = [[[error userInfo] objectForKey:RKObjectMapperErrorObjectsKey] lastObject];
                [SVProgressHUD showErrorWithStatus:[errors messagesString]];
                
                DLog(@"%@", [error description]);
            }];
    }
}

-(BOOL)formIsValid{
    self.errors = [NSMutableArray array];
    for (FFFormSection *section in self.form.sections) {
        for (FFFormField *field in section.fields) {
            if ([field.attributeName isEqualToString:@"comment"]) {
                if (!field.currentValue || [field.currentValue isEqualToString:@""]) {
                    [self.errors addObject:@"Comment cannot be blank"];
                }
            }
        }
    }
    
    return [self.errors count] == 0;
}

@end
