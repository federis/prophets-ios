//
//  QuestionFormViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/13/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <SVProgressHUD.h>

#import "QuestionFormViewController.h"
#import "EditAnswersViewController.h"
#import "Question.h"

@interface QuestionFormViewController ()

@end

@implementation QuestionFormViewController

-(void)prepareForm{
    if (!self.formObject) {
        NSAssert(self.league, @"You must provide a league to create a question");
        
        Question *question = [Question object];
        question.league = self.league;
        self.formObject = question;
    }
    
    FFFormTextField *contentField = [FFFormTextField formFieldWithAttributeName:@"content" labelName:@"Question text"];
    contentField.returnKeyType = UIReturnKeyNext;
    contentField.shouldBecomeFirstResponder = YES;
    
    FFFormDateField *closeOfBettingField = [FFFormDateField formFieldWithAttributeName:@"bettingClosesAt" labelName:@"Close of Betting"];
    closeOfBettingField.initialDate = [NSDate dateWithTimeIntervalSinceNow:86400*7]; //7 days from now
    closeOfBettingField.minimumDate = [NSDate dateWithTimeIntervalSinceNow:60*30]; //30 minutes from now
    
    FFFormTextViewField *descField = [FFFormTextViewField formFieldWithAttributeName:@"desc" labelName:@"Extended Description"];
    
    self.formFields = @[contentField, closeOfBettingField, descField];
    
    self.submitButtonText = @"Submit";
}

-(void)submit{
    [SVProgressHUD showWithStatus:@"Saving question" maskType:SVProgressHUDMaskTypeGradient];
    
    [[RKObjectManager sharedManager] postObject:self.formObject path:nil parameters:nil
    success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"Question saved"];
        
        //send them to answers
        [self performSegueWithIdentifier:@"ShowEditAnswers" sender:self.formObject];
    }
    failure:^(RKObjectRequestOperation *operation, NSError *error){
        [SVProgressHUD dismiss];
        
        [SVProgressHUD showErrorWithStatus:[error description]];
        
        DLog(@"%@", [error description]);
    }];
}

-(BOOL)formIsValid{
    self.errors = [NSMutableArray array];
    
    for (FFFormField *field in self.formFields) {
        if ([field.attributeName isEqualToString:@"content"]) {
            NSString *content = (NSString *)field.currentValue;
            if(content){
                if ([content isEqualToString:@""]) {
                    [self.errors addObject:@"Question text cannot be blank"];
                }
                
                if([content length] < 10) {
                    [self.errors addObject:@"Question text must be at least 10 characters"];
                }
                
                if([content length] > 250) {
                    [self.errors addObject:@"Question cannot be more than 250 characters"];
                }
            }
            else{
                [self.errors addObject:@"Question text cannot be blank"];
            }
            
        }
        
        if ([field.attributeName isEqualToString:@"desc"]) {
            NSString *desc = (NSString *)field.currentValue;
            if(desc){
                if([desc length] > 2000) {
                    [self.errors addObject:@"Description cannot be more than 2000 characters"];
                }
            }            
        }
        
        if ([field.attributeName isEqualToString:@"betting_ends_at"]) {
            if (!field.currentValue || [field.currentValue isEqualToString:@""]) {
                [self.errors addObject:@"Close of betting cannot be blank"];
            }
        }
    }
    
    return [self.errors count] == 0;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ShowEditAnswers"] && [sender isKindOfClass:[Question class]]) {
        EditAnswersViewController *editAnswersVC = (EditAnswersViewController *)[segue destinationViewController];
        editAnswersVC.question = (Question *)sender;
    }
}

-(void)dealloc{
    Question *question = (Question *)self.formObject;
    if (!question.remoteId) {
        [question deleteFromManagedObjectContext];
    }
}

@end
