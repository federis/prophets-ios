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
#import "NSManagedObjectContext+Additions.h"
#import "FFApplicationConstants.h"
#import "RoundedClearBar.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    RoundedClearBar *bar = [[RoundedClearBar alloc] initWithTitle:@"Sign In"];
    [bar.leftButton addTarget:self action:@selector(cancelTouched) forControlEvents:UIControlEventTouchUpInside];
    self.fixedHeaderView = bar;
}

-(void)cancelTouched{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)prepareForm{
    User *user = (User *)[self.scratchContext insertNewObjectForEntityForName:@"User"];
    
    FFFormTextField *emailField = [FFFormTextField formFieldWithAttributeName:@"email"];
    emailField.returnKeyType = UIReturnKeyNext;
    
    FFFormTextField *passwordField = [FFFormTextField formFieldWithAttributeName:@"password"];
    passwordField.returnKeyType = UIReturnKeySend;
    passwordField.secure = YES;
    passwordField.submitsOnReturn = YES;
    
    self.form = [FFForm formForObject:user withFields:@[emailField, passwordField]];
    
    self.submitButtonText = @"Sign In";
}

-(void)submit{
    [SVProgressHUD showWithStatus:@"Logging In" maskType:SVProgressHUDMaskTypeGradient];
    
    [[RKObjectManager sharedManager] postObject:self.form.object path:@"/tokens" parameters:nil
    success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
        [SVProgressHUD dismiss];
        
        NSManagedObjectContext *context = [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
        User *user = (User *)[context objectWithID:[self.form.object objectID]];
        [User setCurrentUser:user];
        [[NSNotificationCenter defaultCenter] postNotificationName:FFUserDidLogInNotification object:user];
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
        
        if ([field.attributeName isEqualToString:@"password"]) {
            if (!field.currentValue || [field.currentValue isEqualToString:@""]) {
                [self.errors addObject:@"Password cannot be blank"];
            }
        }
    }
    
    
    return [self.errors count] == 0;
}

@end
