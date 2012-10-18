//
//  FFFormViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/11/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFFormViewController.h"
#import "FFTableFooterButtonView.h"
#import "FFFormFieldCell.h"
#import "FFFormField.h"
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
}

-(NSArray *)formFields{
    if(!_formFields){
        //set up form fields for all attrs of formObject
        //[Utilities classPropsFor:[self.formObject class]];
    }
    
    return _formFields;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSAssert(self.formObject, @"Cannot create a form table without a form object");
    return self.formFields.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FFFormField *field = [self.formFields objectAtIndex:indexPath.row];
    
    FFFormFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:[FFFormFieldCell cellReuseIdentifierForFormField:field]
                                                          forIndexPath:indexPath];
    cell.formField = field;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    FFTableFooterButtonView *footerView = [FFTableFooterButtonView footerButtonViewForTable:self.tableView withText:self.submitButtonText];
    [footerView.button addTarget:self action:@selector(submitTouched) forControlEvents:UIControlEventTouchUpInside];
    return footerView;
}

-(void)submitTouched{
    [self serializeFormFieldsIntoObject];
    [self submit];
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

-(void)submit{
    //Empty implementation to be overridden by subclasses
}

@end
