//
//  FFFormTextViewCell.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/12/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFFormTextViewFieldCell.h"
#import "FFFormTextViewField.h"

@implementation FFFormTextViewFieldCell

-(void)setFormField:(FFFormField *)formField{
    FFFormTextViewField *field = (FFFormTextViewField *)formField;
    self.textView.text = field.currentValue;
    self.placeholderLabel.text = field.labelName;
    [super setFormField:formField];
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
