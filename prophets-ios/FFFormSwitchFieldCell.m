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
    self.switchControl.on = [field.currentValue boolValue];
    
    [super setFormField:formField];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.switchControl addTarget:self action:@selector(switchChanged) forControlEvents:UIControlEventValueChanged];
}

-(void)switchChanged{
    self.formField.currentValue = [NSNumber numberWithBool:self.switchControl.isOn];
}

@end
