//
//  FormFieldCell.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/17/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FFBaseCell.h"
#import "FFFormField.h"

@interface FFFormFieldCell : FFBaseCell

@property (nonatomic, strong) FFFormField *formField;

+(NSString *)cellReuseIdentifierForFormField:(FFFormField *)field;

-(id)formFieldCurrentValue;

@end
