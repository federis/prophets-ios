//
//  FFFormSwitchFieldCell.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/2/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFFormSwitchFieldCell.h"
#import "FFFormSwitchField.h"

@implementation FFFormSwitchFieldCell

-(void)setFormField:(FFFormField *)formField{
    FFFormSwitchField *field = (FFFormSwitchField *)formField;
    self.attributeNameLabel.text = field.labelName;
    self.switchControl.on = field.isOn;
    
    [super setFormField:formField];
}

-(id)formFieldCurrentValue{
    return [NSNumber numberWithBool:self.switchControl.isOn];
}

@end
