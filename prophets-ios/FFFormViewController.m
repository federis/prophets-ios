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
    FFFormSection *section = self.form.sections[indexPath.section];
    FFFormField *field = (FFFormField *)section.fields[indexPath.row];
    return field.height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.form.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSAssert(self.form.object, @"Cannot create a form table without a form object");
    FFFormSection *sect = self.form.sections[section];
    return sect.fields.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FFFormSection *section = self.form.sections[indexPath.section];
    FFFormField *field = (FFFormField *)section.fields[indexPath.row];
    
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
    if (section != self.form.sections.count - 1) return 0;
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section != self.form.sections.count - 1) return nil;
    
    if(self.footerView) return self.footerView;
    
    self.footerView = [FFTableFooterButtonView footerButtonViewForTable:self.tableView withText:self.submitButtonText];
    [self.footerView.button addTarget:self action:@selector(serializeAndSubmit) forControlEvents:UIControlEventTouchUpInside];
    return self.footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    FFFormSection *formSection = self.form.sections[section];
    if (!formSection.title) return 0;
    
    FFLabel *headerLabel = [[FFLabel alloc] initWithFrame:CGRectMake(10, 10, 300, 30)];
    headerLabel.text = formSection.title;
    [headerLabel sizeToFit];
    return headerLabel.frame.size.height + 20;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    FFFormSection *formSection = self.form.sections[section];
    if (!formSection.title) return nil;
    
    FFLabel *headerLabel = [[FFLabel alloc] initWithFrame:CGRectMake(10, 10, 300, 30)];
    headerLabel.text = formSection.title;
    [headerLabel sizeToFit];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 320, headerLabel.frame.size.height + 20)];
    [v addSubview:headerLabel];
    return v;
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
    
    for (int s=indexPath.section; s<self.form.sections.count; s++) {
        FFFormSection *section = self.form.sections[s];
        for (int i=indexPath.row+1; i<section.fields.count; i++) {
            FFFormField *field = section.fields[i];
            if (field.canBecomeFirstResponder) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:s] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                FFFormFieldCell *nextCell = (FFFormFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:s]];
                if (!nextCell) {
                    field.shouldBecomeFirstResponder = YES;
                }
                else{
                    [nextCell makeFirstResponder];
                }
                
                return YES;
            }
        }
    }
    
    return YES;
}

# pragma mark - FFFormDelegate methods

-(void)formAddedField:(FFFormField *)field inSection:(NSUInteger)section atRow:(NSUInteger)row{
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)formRemovedFieldFromSection:(NSUInteger)section atRow:(NSInteger)row{
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
