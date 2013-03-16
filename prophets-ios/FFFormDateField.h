//
//  FFFormDateField.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/13/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFFormTextField.h"

@interface FFFormDateField : FFFormTextField

@property (nonatomic, strong) NSDate *initialDate;
@property (nonatomic, strong) NSDate *minimumDate;
@property (nonatomic, strong) NSDate *maximumDate;

@end
