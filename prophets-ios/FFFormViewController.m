//
//  FFFormViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/11/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <SVProgressHUD.h>

#import "FFFormViewController.h"
#import "FFTableFooterButtonView.h"
#import "FFFormFieldCell.h"
#import "FFTextFieldCell.h"
#import "FFFormField.h"
#import "FFFormTextField.h"
#import "Utilities.h"

@interface FFFormViewController ()

@property (nonatomic, strong) NSDictionary *formObjectAttributeTypes;

@end

@implementation FFFormViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FFTextFieldCell" bundle:nil]
         forCellReuseIdentifier:@"FFTextFieldCell"];
    
    if(!self.submitButtonText) self.submitButtonText = @"Submit";
    
    [self prepareForm];
}

-(void)prepareForm{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"Invalid method call"
                                           "prepareForm must be implemented by subclasses of FFFormViewController"]
                                 userInfo:nil];
}

-(NSArray *)formFields{
    if(!_formFields){
        //set up form fields for all attrs of formObject
        //[Utilities classPropsFor:[self.formObject class]];
    }
    
    return _formFields;
}

-(void)serializeAndSubmit{
    [self serializeFormFieldsIntoObject];
    if([self formIsValid]){
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
    for (int section = 0; section < [self.tableView numberOfSections]; section++) {
        for (int row = 0; row < [self.tableView numberOfRowsInSection:section]; row++) {
            NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row inSection:section];
            FFFormFieldCell* cell = (FFFormFieldCell *)[self.tableView cellForRowAtIndexPath:cellPath];
            FFFormField *field = [self.formFields objectAtIndex:row];
            
            id value = [cell formFieldCurrentValue];
            [self.formObject setValue:value forKey:field.attributeName];
        }
    }
}

-(BOOL)formIsValid{
    return YES;
}

-(void)submit{
    //Empty implementation to be overridden by subclasses
}


#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSAssert(self.formObject, @"Cannot create a form table without a form object");
    return self.formFields.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id field = [self.formFields objectAtIndex:indexPath.row];
    
    FFFormFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:[field cellReuseIdentifier]
                                                            forIndexPath:indexPath];
    cell.formField = field;
    
    if ([cell isKindOfClass:[FFTextFieldCell class]]) {
        ((FFTextFieldCell *)cell).textField.delegate = self;
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
    if([[[textField superview] superview] isKindOfClass:[FFTextFieldCell class]]){
        FFTextFieldCell *cell = (FFTextFieldCell *)[[textField superview] superview];
        
        if(((FFFormTextField *)cell.formField).submitsOnReturn) {
            [self serializeAndSubmit];
        }
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        NSInteger numRows = [self.tableView numberOfRowsInSection:0];
        
        NSInteger i = indexPath.row + 1;
        FFTextFieldCell *nextTextFieldCell = nil;
        while (!nextTextFieldCell && i < numRows) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if ([cell isKindOfClass:[FFTextFieldCell class]]) {
                nextTextFieldCell = (FFTextFieldCell *)cell;
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
