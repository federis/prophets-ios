//
//  FFFormDateFieldCell.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/13/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "FFFormDateFieldCell.h"
#import "FFFormDateField.h"
#import "NSString+Additions.h"

@implementation FFFormDateFieldCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    self.textField.inputView = datePicker;
    
    [datePicker addTarget:self action:@selector(fieldChanged:) forControlEvents:UIControlEventValueChanged];
}

-(void)fieldChanged:(id)sender{
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    self.textField.text = [self stringForDate:datePicker.date];
    self.formField.currentValue = datePicker.date;
}

-(void)setFormField:(FFFormField *)formField{
    [super setFormField:formField];
    
    FFFormDateField *field = (FFFormDateField *)formField;
    self.attributeNameLabel.text = field.labelName;
    self.textField.text = [self stringForDate:field.currentValue];
    
    UIDatePicker *datePicker = (UIDatePicker *)self.textField.inputView;
    datePicker.date = field.currentValue;
    if (field.minimumDate) {
        datePicker.minimumDate = field.minimumDate;
    }
    
    if (field.maximumDate) {
        datePicker.maximumDate = field.maximumDate;
    }
}

-(NSString *)stringForDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mma MM/dd/yyyy";
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    
    return [dateFormatter stringFromDate:date];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.formField.currentValue = text;
    
    return YES;
}


@end
