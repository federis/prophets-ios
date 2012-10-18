//
//  TextFieldCell.m
//  Inkling Mobile
//
//  Created by Benjamin Roesch on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FFTextFieldCell.h"

@implementation FFTextFieldCell

-(void)setFormField:(FFFormField *)formField{
    self.textField.placeholder = formField.labelName;
    self.textField.secureTextEntry = formField.secure;
}

@end
