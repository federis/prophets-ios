//
//  SettingsViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 1/30/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//



#import <SVProgressHUD.h>

#import "SettingsViewController.h"
#import "RoundedClearBar.h"
#import "User.h"
#import "FFFormSwitchFieldCell.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    RoundedClearBar *bar = [[RoundedClearBar alloc] initWithTitle:@"Settings"];
    [bar.leftButton addTarget:self action:@selector(cancelTouched) forControlEvents:UIControlEventTouchUpInside];
    self.fixedHeaderView = bar;
}

-(void)cancelTouched{
    [self dismissViewControllerAnimated:YES completion:^{}];
}


-(void)prepareForm{
    
    FFFormTextField *emailField = [FFFormTextField formFieldWithAttributeName:@"email"];
    emailField.returnKeyType = UIReturnKeyNext;
    
    FFFormTextField *nameField = [FFFormTextField formFieldWithAttributeName:@"name"];
    nameField.returnKeyType = UIReturnKeyNext;
    
    FFFormSwitchField *notificationsField = [FFFormSwitchField formFieldWithAttributeName:@"wantsNotifications" labelName:@"Send Push Notifications"];
    
    FFFormSwitchField *newQuestionNotificationsField = [FFFormSwitchField formFieldWithAttributeName:@"wantsNewQuestionNotifications" labelName:@"Notifications for New Questions"];
    
    FFFormSwitchField *newCommentNotificationsField = [FFFormSwitchField formFieldWithAttributeName:@"wantsNewCommentNotifications" labelName:@"Notifications for New Comments"];
    
    FFFormSwitchField *questionCreatedNotificationsField = [FFFormSwitchField formFieldWithAttributeName:@"wantsQuestionCreatedNotifications" labelName:@"Notifications for Questions Waiting for Admin Review"];
    
    FFFormTextField *passwordField = [FFFormTextField formFieldWithAttributeName:@"currentPassword" labelName:@"Current Password"];
    passwordField.returnKeyType = UIReturnKeySend;
    passwordField.secure = YES;
    passwordField.submitsOnReturn = YES;
    
    FFFormTextField *newPasswordField = [FFFormTextField formFieldWithAttributeName:@"password" labelName:@"New Password (blank to keep the same)"];
    newPasswordField.returnKeyType = UIReturnKeySend;
    newPasswordField.secure = YES;
    newPasswordField.submitsOnReturn = YES;
    
    NSMutableArray *fields = [NSMutableArray arrayWithArray:@[
                                  emailField,
                                  nameField,
                                  notificationsField,
                                  passwordField,
                                  newPasswordField
                              ]];
    
    if ([[User currentUser].wantsNotifications boolValue]) {
        [fields insertObject:newQuestionNotificationsField atIndex:3];
        [fields insertObject:newCommentNotificationsField atIndex:4];
        [fields insertObject:questionCreatedNotificationsField atIndex:5];
    }
    
    self.form = [FFForm formForObject:[User currentUser] withFields:fields];
    self.form.delegate = self;
    
    self.submitButtonText = @"Save";
}

-(void)submit{
    [SVProgressHUD showWithStatus:@"Saving..." maskType:SVProgressHUDMaskTypeGradient];
    
    [[RKObjectManager sharedManager] putObject:self.form.object path:@"/users" parameters:nil
        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"Saved"];
            
            [User currentUser].currentPassword = nil;
            [[User currentUser].managedObjectContext saveToPersistentStore:nil];
            
            [self dismissViewControllerAnimated:YES completion:^{}];
        }
        failure:^(RKObjectRequestOperation *operation, NSError *error){
            [SVProgressHUD dismiss];
            
            ErrorCollection *errors = [[[error userInfo] objectForKey:RKObjectMapperErrorObjectsKey] lastObject];
            [SVProgressHUD showErrorWithStatus:[errors messagesString]];
        }];
}

-(BOOL)formIsValid{
    self.errors = [NSMutableArray array];
    
    for (FFFormField *field in self.form.fields) {
        if ([field.attributeName isEqualToString:@"email"]) {
            if (!field.currentValue || [field.currentValue isEqualToString:@""]) {
                [self.errors addObject:@"Email cannot be blank"];
            }
        }
        
        if ([field.attributeName isEqualToString:@"name"]) {
            if (!field.currentValue || [field.currentValue isEqualToString:@""]) {
                [self.errors addObject:@"Name cannot be blank"];
            }
        }
        
        if ([field.attributeName isEqualToString:@"currentPassword"]) {
            if (!field.currentValue || [field.currentValue isEqualToString:@""]) {
                [self.errors addObject:@"Current password cannot be blank"];
            }
        }
    }
    
    
    return [self.errors count] == 0;
}

-(void)tableCell:(UITableViewCell *)cell loadedField:(FFFormField *)field{
    if ([field.attributeName isEqualToString:@"wantsNotifications"]) {
        FFFormSwitchFieldCell *switchCell = (FFFormSwitchFieldCell *)cell;
        [switchCell.switchControl addTarget:self action:@selector(wantsNotificationsSwitched:) forControlEvents:UIControlEventValueChanged];
    }
}

-(void)wantsNotificationsSwitched:(id)sender{
    UISwitch *switchControl = (UISwitch *)sender;
    if(switchControl.isOn){
        FFFormSwitchField *newQuestionNotificationsField = [FFFormSwitchField formFieldWithAttributeName:@"wantsNewQuestionNotifications" labelName:@"Notifications for New Questions"];
        
        FFFormSwitchField *newCommentNotificationsField = [FFFormSwitchField formFieldWithAttributeName:@"wantsNewCommentNotifications" labelName:@"Notifications for New Comments"];
        
        FFFormSwitchField *questionCreatedNotificationsField = [FFFormSwitchField formFieldWithAttributeName:@"wantsQuestionCreatedNotifications" labelName:@"Notifications for Questions Waiting for Admin Review"];
        
        [self.form insertFormField:newQuestionNotificationsField atRow:3];
        [self.form insertFormField:newCommentNotificationsField atRow:4];
        [self.form insertFormField:questionCreatedNotificationsField atRow:5];
    }
    else{
        [self.form removeFormFieldAtRow:3];
    }
}


@end
