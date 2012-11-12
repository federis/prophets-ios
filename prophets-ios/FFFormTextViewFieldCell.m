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
    
    [super setFormField:formField];
}

-(id)formFieldCurrentValue{
    return self.textView.text;
}

-(void)makeFirstResponder{
    [self.textView becomeFirstResponder];
}

@end
