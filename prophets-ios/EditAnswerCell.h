//
//  EditAnswerCell.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/14/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFBaseCell.h"

@interface EditAnswerCell : FFBaseCell

@property (weak, nonatomic) IBOutlet UITextField *primaryTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondaryTextField;

@end
