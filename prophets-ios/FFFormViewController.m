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
#import "UIView+Additions.h"

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
}

-(void)prepareForm{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"Invalid method call"
                                           "prepareForm must be implemented by subclasses of FFFormViewController"]
                                 userInfo:nil];
}

-(void)serializeAndSubmit{
    if([self formIsValid]){
        [self.form serializeFormFieldValuesIntoObject];
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

-(BOOL)formIsValid{
    return YES;
}

-(void)submit{
    //Empty implementation to be overridden by subclasses
}

#pragma mark - UITableViewDataSource methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    FFFormField *field = (FFFormField *)[self.form.fields objectAtIndex:indexPath.row];
    return field.height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSAssert(self.form.object, @"Cannot create a form table without a form object");
    return self.form.fields.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FFFormField *field = (FFFormField *)[self.form.fields objectAtIndex:indexPath.row];
    
    FFFormFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:[field cellReuseIdentifier]
                                                            forIndexPath:indexPath];
    cell.formField = field;
    
    [self tableCell:cell loadedField:field];
    
    if ([cell isKindOfClass:[FFFormTextFieldCell class]]) {
        ((FFFormTextFieldCell *)cell).textField.delegate = self;
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

-(void)tableCell:(UITableViewCell *)cell loadedField:(FFFormField *)field{
    //can be overridden by subclasses who need to attach event listeners to cells
}


# pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    FFFormFieldCell *cell = (FFFormFieldCell *)[textField findParentTableViewCell];
    
    if(cell.formField.submitsOnReturn) {
        [self serializeAndSubmit];
        return YES;
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    for (int i=indexPath.row+1; i<self.form.fields.count; i++) {
        FFFormField *field = [self.form.fields objectAtIndex:i];
        if (field.canBecomeFirstResponder) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            FFFormFieldCell *nextCell = (FFFormFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if (!nextCell) {
                field.shouldBecomeFirstResponder = YES;
            }
            else{
                [nextCell makeFirstResponder];
            }
            
            return YES;
        }
    }
    
    return YES;
}

# pragma mark - FFFormDelegate methods

-(void)formAddedField:(FFFormField *)field atRow:(NSUInteger)row{
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)formRemovedFieldAtRow:(NSInteger)row{
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
