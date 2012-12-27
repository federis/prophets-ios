//
//  FFFormViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/11/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <SVProgressHUD.h>
#import <RestKit/RestKit.h>

#import "FFFormViewController.h"
#import "FFTableFooterButtonView.h"
#import "FFFormFieldCell.h"
#import "FFFormTextFieldCell.h"
#import "FFFormTextViewFieldCell.h"
#import "FFFormSwitchFieldCell.h"
#import "FFFormDateFieldCell.h"
#import "FFFormPickerFieldCell.h"
#import "Utilities.h"

@interface FFFormViewController ()

@property (nonatomic, strong) NSDictionary *formObjectAttributeTypes;

@end

@implementation FFFormViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    NSArray *cellNames = @[
        NSStringFromClass([FFFormTextFieldCell class]),
        NSStringFromClass([FFFormTextViewFieldCell class]),
        NSStringFromClass([FFFormSwitchFieldCell class]),
        NSStringFromClass([FFFormDateFieldCell class]),
        NSStringFromClass([FFFormPickerFieldCell class])
    ];
    
    for (NSString *name in cellNames) {
        [self.tableView registerNib:[UINib nibWithNibName:name bundle:nil] forCellReuseIdentifier:name];
    }
    
    if(!self.submitButtonText) self.submitButtonText = @"Submit";
    
    [self prepareForm];
    
    for (FFFormField *field in self.formFields) {
        field.currentValue = [self.formObject valueForKeyPath:field.attributeName];
    }
}

-(void)prepareForm{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"Invalid method call"
                                           "prepareForm must be implemented by subclasses of FFFormViewController"]
                                 userInfo:nil];
}

-(void)serializeAndSubmit{
    if([self formIsValid]){
        [self serializeFormFieldsIntoObject];
        [self submit];
    }
    else{
        NSMutableString *errorString = [NSMutableString string];
        for (NSString *error in self.errors) {
            [errorString appendFormat:@"%@\n", error];
        }
        
        [SVProgressHUD showErrorWithStatus:errorString];
    }
}

-(void)serializeFormFieldsIntoObject{
    for (FFFormField *field in self.formFields) {
        [self.formObject setValue:field.currentValue forKey:field.attributeName];
    }
}

-(BOOL)formIsValid{
    return YES;
}

-(void)submit{
    //Empty implementation to be overridden by subclasses
}

#pragma mark - UITableViewDataSource methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    FFFormField *field = (FFFormField *)[self.formFields objectAtIndex:indexPath.row];
    return field.height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSAssert(self.formObject, @"Cannot create a form table without a form object");
    return self.formFields.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FFFormField *field = (FFFormField *)[self.formFields objectAtIndex:indexPath.row];
    
    FFFormFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:[field cellReuseIdentifier]
                                                            forIndexPath:indexPath];
    cell.formField = field;
    
    if ([cell isKindOfClass:[FFFormTextFieldCell class]]) {
        ((FFFormTextFieldCell *)cell).textField.delegate = self;
    }
    
    if (field.shouldBecomeFirstResponder) {
        [cell makeFirstResponder];
        field.shouldBecomeFirstResponder = NO;
    }

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(self.footerView) return self.footerView;
    
    self.footerView = [FFTableFooterButtonView footerButtonViewForTable:self.tableView withText:self.submitButtonText];
    [self.footerView.button addTarget:self action:@selector(serializeAndSubmit) forControlEvents:UIControlEventTouchUpInside];
    return self.footerView;
}


# pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([[[textField superview] superview] isKindOfClass:[FFFormTextFieldCell class]]){
        FFFormTextFieldCell *cell = (FFFormTextFieldCell *)[[textField superview] superview];
        
        if(((FFFormTextField *)cell.formField).submitsOnReturn) {
            [self serializeAndSubmit];
        }
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        NSInteger numRows = [self.tableView numberOfRowsInSection:0];
        
        NSInteger i = indexPath.row + 1;
        FFFormTextFieldCell *nextTextFieldCell = nil;
        while (!nextTextFieldCell && i < numRows) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if ([cell isKindOfClass:[FFFormTextFieldCell class]]) {
                nextTextFieldCell = (FFFormTextFieldCell *)cell;
            }
            i++;
        }
        
        if (nextTextFieldCell) {
            [nextTextFieldCell.textField becomeFirstResponder];
        }
    }
    
    return YES;
}

@end
