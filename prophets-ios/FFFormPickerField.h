//
//  FFFormPickerField.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 12/26/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFFormTextField.h"

@interface FFFormPickerField : FFFormTextField<UIPickerViewDataSource>

@property (nonatomic, strong) NSArray *pickerOptions;

@end
