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

-(void)setFormField:(FFFormField *)formField{
    FFFormTextField *field = (FFFormTextField *)formField;
    self.textField.placeholder = field.labelName;
    self.textField.secureTextEntry = field.secure;
    self.textField.returnKeyType = field.returnKeyType;
    
    [super setFormField:formField];
}

-(id)formFieldCurrentValue{
  return self.textField.text;
}

@end
