//
//  FFFormTextViewCell.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/12/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFFormTextViewFieldCell.h"
#import "FFFormTextViewField.h"
#import "UIToolbar+Additions.h"

@implementation FFFormTextViewFieldCell

-(void)setFormField:(FFFormField *)formField{
    FFFormTextViewField *field = (FFFormTextViewField *)formField;
    self.textView.text = field.currentValue;
    self.textView.returnKeyType = field.returnKeyType;
    self.placeholderLabel.text = field.labelName;
    
    self.textView.inputAccessoryView = [UIToolbar toolbarWithDoneButtonForResponder:self.textView];
    
    [super setFormField:formField];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if(self.formField.shouldBecomeFirstResponder){
        self.formField.shouldBecomeFirstResponder = NO;
        [self makeFirstResponder];
    }
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.textView.delegate = self;
}

-(void)textViewDidChange:(UITextView *)textView{
    self.formField.currentValue = textView.text;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if (!self.placeholderLabel.hidden) {
        self.placeholderLabel.hidden = YES;
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if ((!textView.text || [textView.text isEqualToString:@""]) && self.placeholderLabel.hidden) {
        self.placeholderLabel.hidden = NO;
    }
}

-(void)makeFirstResponder{
    [self.textView becomeFirstResponder];
}

@end
