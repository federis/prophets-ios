//
//  FFFormTextField.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/19/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFFormField.h"

@interface FFFormTextField : FFFormField

@property (nonatomic) BOOL secure;
@property (nonatomic) BOOL submitsOnReturn;
@property (nonatomic) UIReturnKeyType returnKeyType;

@end
