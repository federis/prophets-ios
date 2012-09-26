//
//  LoginViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/21/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RestKit/UI.h>

#import "LoginViewController.h"
#import "User.h"

@interface LoginViewController ()

@property (nonatomic, strong) RKTableController *tableController;

@end

@implementation LoginViewController

@synthesize tableController;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableController = [[RKObjectManager sharedManager] tableControllerForTableViewController:self];
    
    User *user = [User object];
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
                //loader.targetObject = nil;  // Map the results back onto a new object instead of self
                // Set up a custom serialization mapping to handle this request
                //loader.serializationMapping = [RKObjectMapping serializationMappingUsingBlock:^(RKObjectMapping *mapping) {
                //    [mapping mapAttributes:@"password", nil];
                //}];
            }];
        };
    }];
    
    [self.tableController loadForm:form];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    User *user = [objects objectAtIndex:0];
    [User setCurrentUser:user];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"Encountered an error: %@", error);
}


@end
