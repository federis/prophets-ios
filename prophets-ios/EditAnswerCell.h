//
//  EditAnswerCell.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/14/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFBaseCell.h"

@class Answer;

@interface EditAnswerCell : FFBaseCell<UITextFieldDelegate>

@property (nonatomic, strong) Answer *answer;

@property (weak, nonatomic) IBOutlet UITextField *primaryTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondaryTextField;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;

-(IBAction)secondaryTextFieldChanged:(id)sender;
-(IBAction)primaryTextFieldChanged:(id)sender;

@end
