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
    self.dateField.inputView = datePicker;
    
    [datePicker addTarget:self action:@selector(fieldChanged:) forControlEvents:UIControlEventValueChanged];
}

-(void)fieldChanged:(id)sender{
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    self.dateField.text = [self stringForDate:datePicker.date];
    self.formField.currentValue = datePicker.date; //[self.dateField.text dateFromLocalStringUsingFormat:@"MM/dd/yy hh:mma"];
}


-(void)setFormField:(FFFormField *)formField{
    FFFormDateField *field = (FFFormDateField *)formField;
    self.attributeNameLabel.text = field.labelName;
    self.dateField.text = [self stringForDate:field.initialDate];
    
    UIDatePicker *datePicker = (UIDatePicker *)self.dateField.inputView;
    datePicker.date = field.initialDate;
    if (field.minimumDate) {
        datePicker.minimumDate = field.minimumDate;
    }
    
    if (field.maximumDate) {
        datePicker.maximumDate = field.maximumDate;
    }
    
    [super setFormField:formField];
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

-(void)makeFirstResponder{
    [self.dateField becomeFirstResponder];
}


@end
