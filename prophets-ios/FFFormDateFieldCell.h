//
//  FFFormDateFieldCell.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/13/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFFormFieldCell.h"

@interface FFFormDateFieldCell : FFFormFieldCell

@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UILabel *attributeNameLabel;

@end
