//
//  LoginViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/21/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <SVProgressHUD.h>

#import "LoginViewController.h"
#import "User.h"
#import "NSManagedObject+Additions.h"
#import "FFApplicationConstants.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

-(void)prepareForm{
    User *user = [User object];
    self.formObject = user;
    
    FFFormTextField *emailField = [FFFormTextField formFieldWithAttributeName:@"email"];
    emailField.returnKeyType = UIReturnKeyNext;
    
    FFFormTextField *passwordField = [FFFormTextField formFieldWithAttributeName:@"password"];
    passwordField.returnKeyType = UIReturnKeySend;
    passwordField.secure = YES;
    passwordField.submitsOnReturn = YES;
    
    self.formFields = @[ emailField, passwordField ];
    
    self.submitButtonText = @"Sign In";
}

-(void)submit{
    [SVProgressHUD showWithStatus:@"Logging In" maskType:SVProgressHUDMaskTypeGradient];
    
    [[RKObjectManager sharedManager] postObject:self.formObject path:@"/tokens" parameters:nil
    success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
        [SVProgressHUD dismiss];
        
        User *user = (User *)self.formObject;
        [User setCurrentUser:user];
        [[NSNotificationCenter defaultCenter] postNotificationName:FFUserDidLogInNotification object:user];
    }
    failure:^(RKObjectRequestOperation *operation, NSError *error){
        [SVProgressHUD dismiss];
        
        [SVProgressHUD showErrorWithStatus:[error description]];
    }];
}

-(BOOL)formIsValid{
    self.errors = [NSMutableArray array];
    User *user = (User *)self.formObject;
    if (!user.email || [user.email isEqualToString:@""]) {
        [self.errors addObject:@"Email cannot be blank"];
    }
    
    if (!user.password || [user.password isEqualToString:@""]) {
        [self.errors addObject:@"Password cannot be blank"];
    }
    
    return [self.errors count] == 0;
}

@end
