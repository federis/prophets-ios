//
//  LeagueSettingsViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/2/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <SVProgressHUD.h>

#import "LeagueSettingsViewController.h"
#import "Membership.h"

@interface LeagueSettingsViewController ()

@end

@implementation LeagueSettingsViewController

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    FFLabel *l = [[FFLabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];
    l.text = @"Nothing to see here yet. Move along.";
    l.textAlignment = UITextAlignmentCenter;
    return l;
}


-(void)prepareForm{
    /*
    FFFormTextField *emailField = [FFFormTextField formFieldWithAttributeName:@"email"];
    emailField.returnKeyType = UIReturnKeyNext;
    
    FFFormTextField *nameField = [FFFormTextField formFieldWithAttributeName:@"name"];
    nameField.returnKeyType = UIReturnKeyNext;
    
    FFFormTextField *newPasswordField = [FFFormTextField formFieldWithAttributeName:@"password" labelName:@"New Password (blank to keep the same)"];
    newPasswordField.returnKeyType = UIReturnKeyNext;
    newPasswordField.secure = YES;
    
    FFFormTextField *passwordField = [FFFormTextField formFieldWithAttributeName:@"currentPassword" labelName:@"Current Password"];
    passwordField.returnKeyType = UIReturnKeySend;
    passwordField.secure = YES;
    passwordField.submitsOnReturn = YES;
     */
    
    self.form = [FFForm formForObject:self.membership withFields:@[ ]];
    
    self.submitButtonText = @"Save";
}
/*
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
*/

@end
