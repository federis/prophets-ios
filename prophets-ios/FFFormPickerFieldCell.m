//
//  FFFormPickerFieldCell.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 12/26/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "FFFormPickerFieldCell.h"
#import "FFFormPickerField.h"
#import "NSString+Additions.h"

@implementation FFFormPickerFieldCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    UIPickerView *tagPicker = [[UIPickerView alloc] init];
    self.textField.inputView = tagPicker;
    tagPicker.delegate = self;
    tagPicker.showsSelectionIndicator = YES;
}

-(void)setFormField:(FFFormField *)formField{
    [super setFormField:formField];
    
    FFFormPickerField *field = (FFFormPickerField *)formField;
    self.attributeNameLabel.text = field.labelName;
    
    UIPickerView *tagPicker = (UIPickerView *)self.textField.inputView;
    tagPicker.dataSource = field;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    FFFormPickerField *field = (FFFormPickerField *)self.formField;
    return [[field pickerOptions] objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    FFFormPickerField *field = (FFFormPickerField *)self.formField;
    self.textField.text = [[field pickerOptions] objectAtIndex:row];
    self.formField.currentValue = [[field pickerOptions] objectAtIndex:row];
}

@end
