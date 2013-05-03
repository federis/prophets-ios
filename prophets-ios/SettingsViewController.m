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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FacebookConnectCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"FacebookConnectCell"];
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
    
    FFFormSwitchField *newQuestionNotificationsField = [FFFormSwitchField formFieldWithAttributeName:@"wantsNewQuestionNotifications" labelName:@"New Questions Published"];
    
    FFFormSwitchField *newCommentNotificationsField = [FFFormSwitchField formFieldWithAttributeName:@"wantsNewCommentNotifications" labelName:@"New Comments"];
    
    FFFormSwitchField *questionCreatedNotificationsField = [FFFormSwitchField formFieldWithAttributeName:@"wantsQuestionCreatedNotifications" labelName:@"Questions Awaiting Admin Review"];
    
    FFFormTextField *passwordField = [FFFormTextField formFieldWithAttributeName:@"currentPassword" labelName:@"Current Password"];
    passwordField.returnKeyType = UIReturnKeySend;
    passwordField.secure = YES;
    passwordField.submitsOnReturn = YES;
    
    FFFormTextField *newPasswordField = [FFFormTextField formFieldWithAttributeName:@"password" labelName:@"New Password (blank to keep the same)"];
    newPasswordField.returnKeyType = UIReturnKeySend;
    newPasswordField.secure = YES;
    newPasswordField.submitsOnReturn = YES;
    
    NSArray *contentFields = @[
                                emailField,
                                nameField,
                                passwordField,
                                newPasswordField
                              ];
    
    FFFormSection *contentSection = [[FFFormSection alloc] initWithFields:contentFields title:nil];
    
    NSMutableArray *notificationFields = [NSMutableArray arrayWithObject:notificationsField];
    
    if ([[User currentUser].wantsNotifications boolValue]) {
        [notificationFields insertObject:newQuestionNotificationsField atIndex:1];
        [notificationFields insertObject:newCommentNotificationsField atIndex:2];
        [notificationFields insertObject:questionCreatedNotificationsField atIndex:3];
    }
    
    FFFormSection *notificationsSection = [[FFFormSection alloc] initWithFields:notificationFields title:@"Notifications"];
    
    FFFormField *connectField = [FFFormField formFieldWithAttributeName:@"fbUid"];
    connectField.customCellReuseIdentifier = @"FacebookConnectCell";
    NSMutableArray *socialFields = [NSMutableArray arrayWithObject:connectField];
    
    if ([User currentUser].fbUid) {
        FFFormSwitchField *publishBetsField = [FFFormSwitchField formFieldWithAttributeName:@"publishBetsToFB" labelName:@"Publish Bets to FB"];
        [socialFields addObject:publishBetsField];
    }
    
    FFFormSection *socialSection = [[FFFormSection alloc] initWithFields:socialFields title:@"Social"];
    
    self.form = [[FFForm alloc] initWithObject:[User currentUser] sections:@[contentSection, notificationsSection, socialSection]];
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
    
    for (FFFormSection *section in self.form.sections) {
        for (FFFormField *field in section.fields) {
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
    }
    
    return [self.errors count] == 0;
}

-(void)tableCell:(UITableViewCell *)cell loadedField:(FFFormField *)field{
    if ([cell isKindOfClass:[FFFormSwitchFieldCell class]]){
        FFFormSwitchFieldCell *switchCell = (FFFormSwitchFieldCell *)cell;
        
        if ([field.attributeName isEqualToString:@"wantsNotifications"]) {
            [switchCell.switchControl addTarget:self action:@selector(wantsNotificationsSwitched:) forControlEvents:UIControlEventValueChanged];
        }
        else{
            [switchCell.switchControl removeTarget:self action:@selector(wantsNotificationsSwitched:) forControlEvents:UIControlEventValueChanged];
        }
    }
}

-(void)wantsNotificationsSwitched:(id)sender{
    UISwitch *switchControl = (UISwitch *)sender;
    if(switchControl.isOn){
        FFFormSwitchField *newQuestionNotificationsField = [FFFormSwitchField formFieldWithAttributeName:@"wantsNewQuestionNotifications" labelName:@"New Questions Published"];
        
        FFFormSwitchField *newCommentNotificationsField = [FFFormSwitchField formFieldWithAttributeName:@"wantsNewCommentNotifications" labelName:@"New Comments"];
        
        FFFormSwitchField *questionCreatedNotificationsField = [FFFormSwitchField formFieldWithAttributeName:@"wantsQuestionCreatedNotifications" labelName:@"Questions Awaiting Admin Review"];
        
        [self.form insertFormField:newQuestionNotificationsField inSection:1 atRow:1];
        [self.form insertFormField:newCommentNotificationsField inSection:1 atRow:2];
        [self.form insertFormField:questionCreatedNotificationsField inSection:1 atRow:3];
    }
    else{
        [self.form removeFormFieldFromSection:1 atRow:3];
        [self.form removeFormFieldFromSection:1 atRow:2];
        [self.form removeFormFieldFromSection:1 atRow:1];
    }
}


@end
