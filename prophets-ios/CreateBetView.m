//
//  CreateBetView.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/3/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "CreateBetView.h"
#import "Utilities.h"
#import "Answer.h"
#import "Question.h"
#import "Membership.h"
#import "Bet.h"

@implementation CreateBetView

+(CGFloat)heightForViewWithAnswer:(Answer *)answer{
    return [Utilities heightForString:answer.content
                             withFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:16]
                                width:300] + 180;
}

-(id)initWithBet:(Bet *)bet inAnswer:(Answer *)answer forMembership:(Membership *)membership{
    self = [self init];
    if (self) {
        self.bet = bet;
        self.answer = answer;
        self.membership = membership;
        
        self.bet.probability = self.answer.currentProbability;
        self.bet.amount = [NSDecimalNumber decimalNumberWithString:@"1.0"];
        
        self.answerNameLabel.text = answer.content;
        self.currentOddsLabel.text = answer.currentOddsString;
        self.payoutLabel.text = self.bet.potentialPayout.currencyString;
        
        [self.answerNameLabel sizeToFit];
        self.answerNameLabel.frame = SameOriginRectWithSize(self.answerNameLabel.frame.size.width + 5, self.answerNameLabel.frame.size.height, self.answerNameLabel.frame);
        
        self.containerView.frame = SameSizeRectAt(self.containerView.frame.origin.x,
                                                  self.answerNameLabel.frame.origin.y + self.answerNameLabel.frame.size.height,
                                                  self.containerView.frame);
        
        [self sizeToFit];
        
        self.maxBetLabel.text = membership.maxBet.currencyString;
        
        self.betAmountSlider.maximumValue = [membership.maxBet floatValue];
    }
    
    return self;
}

-(id)init{
    NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                          owner:nil
                                                        options:nil];
    
    if ([arrayOfViews count] < 1) return nil;
    
    self = [arrayOfViews objectAtIndex:0];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(4, 4, 4, 4);
    UIImage *buttonImage = [[UIImage imageNamed:@"green_button_insets.png"] resizableImageWithCapInsets:insets];
    [self.submitBetButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    
    self.betAmountTextField.delegate = self;
    self.betAmountTextField.keyboardType = UIKeyboardTypeDecimalPad;
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.tintColor = [UIColor blackColor];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleBordered target:self.betAmountTextField action:@selector(resignFirstResponder)];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                            target:nil action:nil];
    [toolbar setItems:@[spacer, doneButton]];
    self.betAmountTextField.inputAccessoryView = toolbar;
    
    return self;
}

-(IBAction)sliderChanged:(id)sender{
    self.bet.amount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%0.2f", self.betAmountSlider.value]];
    
    self.payoutLabel.text = self.bet.potentialPayout.currencyString;
    
    self.betAmountTextField.text = [NSString stringWithFormat:@"%0.2f", self.betAmountSlider.value];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSDecimalNumber *val = [NSDecimalNumber decimalNumberWithString:text];
    
    if ([val isEqualToNumber:[NSDecimalNumber notANumber]]){
        self.bet.amount = nil;
        self.payoutLabel.text = @"-";
        self.betAmountSlider.value = 0;
    }
    else{
        self.bet.amount = val;
        self.payoutLabel.text = self.bet.potentialPayout.currencyString;
        self.betAmountSlider.value = [val floatValue];
    }
    
    return YES;
}

@end
