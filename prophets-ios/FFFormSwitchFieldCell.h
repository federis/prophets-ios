//
//  FFFormSwitchFieldCell.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/2/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFFormFieldCell.h"

@interface FFFormSwitchFieldCell : FFFormFieldCell
@property (weak, nonatomic) IBOutlet UILabel *attributeNameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchControl;

@end
