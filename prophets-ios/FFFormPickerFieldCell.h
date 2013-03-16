//
//  FFFormPickerFieldCell.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 12/26/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFFormTextFieldCell.h"

@interface FFFormPickerFieldCell : FFFormTextFieldCell<UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *attributeNameLabel;

@end
