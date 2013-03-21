//
//  CorrectnessDateViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 3/4/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import <SVProgressHUD.h>
#import <RestKit/RestKit.h>

#import "CorrectnessDateViewController.h"
#import "Answer.h"
#import "Question.h"
#import "UIColor+Additions.h"

@interface CorrectnessDateViewController ()

@end

@implementation CorrectnessDateViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(4, 4, 4, 4);
    UIImage *blueImage = [[UIImage imageNamed:@"blue_button_insets.png"] resizableImageWithCapInsets:insets];
    [self.saveButton setBackgroundImage:blueImage forState:UIControlStateNormal];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    self.correctnessDateField.inputView = datePicker;
    
    [datePicker addTarget:self action:@selector(fieldChanged:) forControlEvents:UIControlEventValueChanged];
}

-(void)fieldChanged:(id)sender{
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    self.correctnessDateField.text = [self stringForDate:datePicker.date];
}

-(NSString *)stringForDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yyyy   hh:mma";
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    
    return [dateFormatter stringFromDate:date];
}

-(IBAction)segmentControlChanged:(id)sender{
    UISegmentedControl *segControl = (UISegmentedControl *)sender;
    if ([segControl selectedSegmentIndex] == 0) {
        self.correctnessDateField.enabled = NO;
        self.correctnessDateField.backgroundColor = [UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:0.25];
    }
    else{
        self.correctnessDateField.enabled = YES;
        self.correctnessDateField.backgroundColor = [UIColor creamColor];
    }
}

-(IBAction)saveTouched:(id)sender{
    NSURL *url = [[RKObjectManager sharedManager].router URLForRouteNamed:@"judge_answer" method:nil object:self.answer];
    
    [SVProgressHUD showWithStatus:@"Judging answer" maskType:SVProgressHUDMaskTypeGradient];
    
    if (self.correctnessDateField.enabled) {
        UIDatePicker *datePicker = (UIDatePicker *)self.correctnessDateField.inputView;
        self.answer.correctnessKnownAt = datePicker.date;
    }
    else{
        self.answer.correctnessKnownAt = [NSDate date];
    }
    
    NSDictionary *params = @{@"answer[correct]": self.answer.correct, @"answer[correctness_known_at]" : self.answer.correctnessKnownAt};
    [[RKObjectManager sharedManager] putObject:nil path:[url relativePath] parameters:params
       success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
           [SVProgressHUD dismiss];
           [SVProgressHUD showSuccessWithStatus:@"Answer judged"];
           
           if (self.answer.isCorrect) {
               for (Answer *otherAnswer in self.answer.question.answers) {
                   if ([self.answer.remoteId integerValue] != [otherAnswer.remoteId integerValue]) {
                       otherAnswer.isCorrect = NO;
                       otherAnswer.correctnessKnownAt = self.answer.correctnessKnownAt;
                       otherAnswer.judgedAt = self.answer.judgedAt;
                   }
               }
           }
           
           if (self.answer.question.allAnswersJudged) {
               self.answer.question.completedAt = self.answer.judgedAt;
           }
           
           if(self.answer.managedObjectContext.hasChanges){
               [self.answer.managedObjectContext save:nil];
           }
           
           [self.navigationController popViewControllerAnimated:YES];
       }
       failure:^(RKObjectRequestOperation *operation, NSError *error){
           [SVProgressHUD dismiss];
           
           ErrorCollection *errors = [[[error userInfo] objectForKey:RKObjectMapperErrorObjectsKey] lastObject];
           [SVProgressHUD showErrorWithStatus:[errors messagesString]];
           
           DLog(@"%@", [error description]);
       }];
}

@end
