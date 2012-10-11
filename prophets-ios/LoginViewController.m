//
//  LoginViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/21/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <RestKit/RestKit.h>

#import "LoginViewController.h"
#import "User.h"

@interface LoginViewController ()
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    /* revisit
    self.tableController = [[RKObjectManager sharedManager] tableControllerForTableViewController:self];
    User *user = [User tempObject];
    RKForm *form = [RKForm formForObject:user usingBlock:^(RKForm *form) {
        [form addSectionUsingBlock:^(RKFormSection *section) {
            
            [section addRowForAttribute:@"email" withControlType:RKFormControlTypeTextField usingBlock:^(RKControlTableItem *tableItem) {
                tableItem.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                tableItem.textField.returnKeyType = UIReturnKeyNext;
                tableItem.textField.keyboardType = UIKeyboardTypeEmailAddress;
                tableItem.textField.keyboardAppearance = UIKeyboardAppearanceAlert;
                //tableItem.textField.delegate = self;
                tableItem.textField.placeholder = @"Email Address";
                [tableItem.textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
                [tableItem.textField setAutocorrectionType:UITextAutocorrectionTypeNo];
            }];
            
            [section addRowForAttribute:@"password" withControlType:RKFormControlTypeTextFieldSecure usingBlock:^(RKControlTableItem *tableItem) {
                tableItem.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                tableItem.textField.returnKeyType = UIReturnKeyDone;
                tableItem.textField.keyboardAppearance = UIKeyboardAppearanceAlert;
                //tableItem.textField.delegate = self;
                tableItem.textField.placeholder = @"Password";
                [tableItem.textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
                [tableItem.textField setAutocorrectionType:UITextAutocorrectionTypeNo];
            }];
            
        }];
        
        [form addSectionUsingBlock:^(RKFormSection *section) {
            RKTableItem *tableItem = [RKTableItem tableItem];
            tableItem.cellMapping.reuseIdentifier = @"SignInCell";
            tableItem.cellMapping.selectionStyle = UITableViewCellSelectionStyleNone;
            tableItem.cellMapping.onSelectCellForObjectAtIndexPath = ^(UITableViewCell *cell, id object, NSIndexPath* indexPath) {
                [form submit];
            };
            [section addTableItem:tableItem];
        }];
        
        form.onSubmit = ^ {
            User *user = (User *) form.object;
            NSLog(@"signin: email=%@, password=%@", user.email, user.password);
            [[RKObjectManager sharedManager] sendObject:user toResourcePath:@"/tokens" usingBlock:^(RKObjectLoader *loader) {
                loader.delegate = self;
                loader.method = RKRequestMethodPOST;
                loader.serializationMIMEType = RKMIMETypeJSON; // We want to send this request as JSON
                [loader.serializationMapping mapAttributes:@"password", nil];
                loader.targetObject = nil;  // Map the results back onto a new object instead of self
                // Set up a custom serialization mapping to handle this request
                //loader.serializationMapping = [RKObjectMapping serializationMappingUsingBlock:^(RKObjectMapping *mapping) {
                //    [mapping mapAttributes:@"password", nil];
                //}];
            }];
        };
    }];
    
    [self.tableController loadForm:form];
     */
}
/*
- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    User *user = [objects objectAtIndex:0];
    
    [User setCurrentUser:user];
    [[RKObjectManager sharedManager].objectStore save:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FFUserDidLogInNotification object:user];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"Encountered an error: %@", error);
}
*/


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
