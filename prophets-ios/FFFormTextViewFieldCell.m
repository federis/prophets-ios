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
    [super setFormField:formField];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.textView.delegate = self;
}

-(void)textViewDidChange:(UITextView *)textView{
    self.formField.currentValue = textView.text;
}

-(void)makeFirstResponder{
    [self.textView becomeFirstResponder];
}

@end
