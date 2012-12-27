//
//  FFFormPickerField.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 12/26/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFFormPickerField.h"

@implementation FFFormPickerField

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.pickerOptions count];
}

@end
