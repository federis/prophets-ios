//
//  FFFormPickerField.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 12/26/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFFormField.h"

@interface FFFormPickerField : FFFormField<UIPickerViewDataSource>

@property (nonatomic, strong) NSArray *pickerOptions;

@end
