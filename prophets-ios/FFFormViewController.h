//
//  FFFormViewController.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/11/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFBaseTableViewController.h"
#import "FFFormField.h"
#import "FFFormTextField.h"
#import "FFFormSwitchField.h"
#import "FFFormTextViewField.h"
#import "FFFormDateField.h"
#import "FFFormPickerField.h"
#import "FFFormSection.h"
#import "FFForm.h"

@class FFTableFooterButtonView;

@interface FFFormViewController : FFBaseTableViewController<UITextFieldDelegate, FFFormDelegate>

@property (nonatomic, strong) FFForm *form;
@property (nonatomic, strong) NSMutableArray *errors;
@property (nonatomic, strong) NSString *submitButtonText;
@property (nonatomic, strong) FFTableFooterButtonView *footerView;

-(void)prepareForm;
-(void)submit;
-(void)tableCell:(UITableViewCell *)cell loadedField:(FFFormField *)field;

@end
