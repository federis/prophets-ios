//
//  EditAnswerCell.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/14/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "EditAnswerCell.h"
#import "Answer.h"

@implementation EditAnswerCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.tintColor = [UIColor blackColor];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleBordered target:self.secondaryTextField action:@selector(resignFirstResponder)];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                            target:nil action:nil];
    [toolbar setItems:@[spacer, doneButton]];
    self.secondaryTextField.inputAccessoryView = toolbar;
}

-(void)setAnswer:(Answer *)answer{
    _answer = answer;
    
    self.primaryTextField.text = answer.content;
    
    self.secondaryTextField.text = [[answer.initialProbability decimalNumberByRoundingToTwoDecimalPlaces] stringValue];
    
    [answer addObserver:self forKeyPath:@"initialProbability" options:NSKeyValueObservingOptionNew context:nil];
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
    [self.answer removeObserver:self forKeyPath:@"initialProbability"];
}

@end
