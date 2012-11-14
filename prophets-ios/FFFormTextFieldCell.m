//
//  TextFieldCell.m
//  Inkling Mobile
//
//  Created by Benjamin Roesch on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FFFormTextFieldCell.h"
#import "FFFormTextField.h"

@implementation FFFormTextFieldCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.textField addTarget:self action:@selector(fieldChanged) forControlEvents:UIControlEventEditingChanged];
}

-(void)fieldChanged{
    self.formField.currentValue = self.textField.text;
}


-(void)setFormField:(FFFormField *)formField{
    FFFormTextField *field = (FFFormTextField *)formField;
    self.textField.placeholder = field.labelName;
    self.textField.secureTextEntry = field.secure;
    self.textField.returnKeyType = field.returnKeyType;
    
    [super setFormField:formField];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.formField.currentValue = text;
 
    return YES;
}

-(void)makeFirstResponder{
    [self.textField becomeFirstResponder];
}

@end
