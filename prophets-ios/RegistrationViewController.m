//
//  RegistrationViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/7/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <SVProgressHUD.h>

#import "RegistrationViewController.h"
#import "User.h"
#import "NSManagedObject+Additions.h"
#import "FFApplicationConstants.h"
#import "RoundedClearBar.h"
#import "FFFacebook.h"

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    RoundedClearBar *bar = [[RoundedClearBar alloc] initWithTitle:@"Sign Up"];
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
    
    FFFormTextField *nameField = [FFFormTextField formFieldWithAttributeName:@"name"];
    nameField.returnKeyType = UIReturnKeyNext;
    
    FFFormTextField *passwordField = [FFFormTextField formFieldWithAttributeName:@"password"];
    passwordField.returnKeyType = UIReturnKeySend;
    passwordField.secure = YES;
    passwordField.submitsOnReturn = YES;
    
    self.form = [FFForm formForObject:user withFields:@[ emailField, nameField, passwordField ]];
    
    self.submitButtonText = @"Register";
}

-(void)submit{
    [SVProgressHUD showWithStatus:@"Signing Up" maskType:SVProgressHUDMaskTypeGradient];
    
    [[RKObjectManager sharedManager] postObject:self.form.object path:@"/users" parameters:@{@"registration_secret" : FFRegistrationSecret}
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
            
            if ([field.attributeName isEqualToString:@"password"]) {
                if (!field.currentValue || [field.currentValue isEqualToString:@""]) {
                    [self.errors addObject:@"Password cannot be blank"];
                }
            }
        }
    }
    
    
    return [self.errors count] == 0;
}

-(IBAction)facebookButtonTouched:(id)sender{
    if ([FBSession activeSession].isOpen) {
        [FFFacebook logInWithFacebookSession:[FBSession activeSession] success:^{} failure:^(NSError *err){}];
    }
    else{
        [FBSession openActiveSessionWithReadPermissions:@[] allowLoginUI:YES
          completionHandler:^(FBSession *session, FBSessionState state, NSError *err){
              [FFFacebook logInWithFacebookSession:session success:^{} failure:^(NSError *err){}];
          }];
    }
}

@end
