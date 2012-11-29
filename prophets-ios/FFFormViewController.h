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

@class FFTableFooterButtonView;

@interface FFFormViewController : FFBaseTableViewController<UITextFieldDelegate>

@property (nonatomic, strong) id formObject;
@property (nonatomic, strong) NSArray *formFields;
@property (nonatomic, strong) NSMutableArray *errors;
@property (nonatomic, strong) NSString *submitButtonText;
@property (nonatomic, strong) FFTableFooterButtonView *footerView;
@property (nonatomic, strong) NSManagedObjectContext *scratchContext;

-(void)prepareForm;
-(void)submit;

@end
