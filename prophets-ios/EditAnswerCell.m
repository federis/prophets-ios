//
//  EditAnswerCell.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/14/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "EditAnswerCell.h"
#import "Answer.h"
#import "UIToolbar+Additions.h"

@implementation EditAnswerCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.primaryTextField.inputAccessoryView = [UIToolbar toolbarWithDoneButtonForResponder:self.primaryTextField];
    self.secondaryTextField.inputAccessoryView = [UIToolbar toolbarWithDoneButtonForResponder:self.secondaryTextField];
}

-(void)setAnswer:(Answer *)answer{
    if (_answer) { //if this cell is being reused, we need to remove the old observer
        [_answer removeObserver:self forKeyPath:@"initialProbability"];
    }
    
    _answer = answer;
    
    self.primaryTextField.text = answer.content;
    
    self.secondaryTextField.text = [[answer.initialProbability decimalNumberByRoundingToTwoDecimalPlaces] stringValue];
    
    [_answer addObserver:self forKeyPath:@"initialProbability" options:NSKeyValueObservingOptionNew context:nil];
}

-(IBAction)secondaryTextFieldChanged:(id)sender{
    self.answer.initialProbability = [NSDecimalNumber decimalNumberWithString:self.secondaryTextField.text];
}

-(IBAction)primaryTextFieldChanged:(id)sender{
    self.answer.content = self.primaryTextField.text;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    NSDecimalNumber *initProb = [self.answer.initialProbability decimalNumberByRoundingToTwoDecimalPlaces];
    NSDecimalNumber *currentVal = [NSDecimalNumber decimalNumberWithString:self.secondaryTextField.text];
    if ([keyPath isEqualToString:@"initialProbability"] &&
        ![currentVal isEqualToNumber:initProb]) {
        self.secondaryTextField.text = [initProb stringValue];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *text = [self.secondaryTextField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (![text hasPrefix:@"0."]) {
        return NO;
    }
    if ([text length] > 4) {
        return NO;
    }
    
    return YES;
}

-(void)dealloc{
    [_answer removeObserver:self forKeyPath:@"initialProbability"];
    [self.removeButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
}

@end
