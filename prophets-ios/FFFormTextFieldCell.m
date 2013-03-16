//
//  TextFieldCell.m
//  Inkling Mobile
//
//  Created by Benjamin Roesch on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FFFormTextFieldCell.h"
#import "FFFormTextField.h"
#import "UIToolbar+Additions.h"

@implementation FFFormTextFieldCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.textField addTarget:self action:@selector(fieldChanged) forControlEvents:UIControlEventEditingChanged];
    self.textField.inputAccessoryView = [UIToolbar toolbarWithDoneButtonForResponder:self.textField];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if(self.formField.shouldBecomeFirstResponder){
        self.formField.shouldBecomeFirstResponder = NO;
        [self makeFirstResponder];
    }
}

-(void)fieldChanged{
    self.formField.currentValue = self.textField.text;
}


-(void)setFormField:(FFFormField *)formField{
    FFFormTextField *field = (FFFormTextField *)formField;
    self.textField.placeholder = field.labelName;
    self.textField.secureTextEntry = field.secure;
    self.textField.returnKeyType = field.returnKeyType;
    self.textField.text = field.currentValue ? [NSString stringWithFormat:@"%@", field.currentValue] : nil;
    
    [super setFormField:formField];
}

-(void)makeFirstResponder{
    [self.textField becomeFirstResponder];
}

@end
