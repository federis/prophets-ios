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

@interface CommentFormViewController ()

@end

@implementation CommentFormViewController


-(void)prepareForm{
    if (!self.formObject) {
        //Comments should be in either a league or a question, but not both
        NSAssert(self.question || self.league, @"You must provide a league or question for the comment");
        NSAssert(!(self.question && self.league), @"You cannot provide both a league and question for the comment");
        
        Comment *comment = [Comment object];
        if (self.question) {
            comment.question = self.question;
        }
        else if(self.league){
            comment.league = self.league;
        }
        
        self.formObject = comment;
    }
    
    FFFormTextViewField *commentField = [FFFormTextViewField formFieldWithAttributeName:@"comment"];
    commentField.shouldBecomeFirstResponder = YES;
    self.formFields = @[commentField];
    
    self.submitButtonText = @"Submit";
}

-(void)submit{
    [SVProgressHUD showWithStatus:@"Submitting comment" maskType:SVProgressHUDMaskTypeGradient];
    
    Comment *comment = (Comment *)self.formObject;
    NSString *path = nil;
    if(comment.question){
        path = [NSString stringWithFormat:@"/questions/%@/comments", comment.question.remoteId];
    }
    else{
        path = [NSString stringWithFormat:@"/leagues/%@/comments", comment.league.remoteId];
    }
    
    [[RKObjectManager sharedManager] postObject:self.formObject path:path parameters:nil
        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"Comment created"];
            DLog(@"%@", mappingResult);
            
            [self dismissViewControllerAnimated:YES completion:^{}];
        }
        failure:^(RKObjectRequestOperation *operation, NSError *error){
            [SVProgressHUD dismiss];
            
            [SVProgressHUD showErrorWithStatus:[error description]];
            
            DLog(@"%@", [error description]);
        }];
}

-(BOOL)formIsValid{
    self.errors = [NSMutableArray array];
    Comment *comment = (Comment *)self.formObject;
    if (!comment.comment || [comment.comment isEqualToString:@""]) {
        [self.errors addObject:@"Comment cannot be blank"];
    }
    
    return [self.errors count] == 0;
}

@end