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
    self.form = [FFForm formForObject:user withFields:[self formFields]];
    self.submitButtonText = @"Register";
}

-(NSArray *)formFields{
    FFFormTextField *emailField = [FFFormTextField formFieldWithAttributeName:@"email"];
    emailField.returnKeyType = UIReturnKeyNext;
    
    FFFormTextField *nameField = [FFFormTextField formFieldWithAttributeName:@"name"];
    nameField.returnKeyType = UIReturnKeyNext;
    
    FFFormTextField *passwordField = [FFFormTextField formFieldWithAttributeName:@"password"];
    passwordField.returnKeyType = UIReturnKeySend;
    passwordField.secure = YES;
    passwordField.submitsOnReturn = YES;
    
    return @[ emailField, nameField, passwordField ];
}

-(void)submit{
    [SVProgressHUD showWithStatus:@"Signing Up" maskType:SVProgressHUDMaskTypeGradient];
    
    [[RKObjectManager sharedManager] postObject:self.form.object path:@"/users" parameters:@{@"registration_secret" : FFRegistrationSecret}
    success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
        [SVProgressHUD dismiss];
        
        NSManagedObjectContext *context = [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
        User *user = (User *)[context objectWithID:[self.form.object objectID]];
        [User setCurrentUser:user];
        
        [Utilities showOkAlertWithTitle:@"Welcome to 55Prophets!" message:@"55Prophets is a fantasy betting app. Find a league that interests you and join, or you can create your own league. In each league, you start with some of our virtual currency, prophits (\u01A4), that you can use to place bets. Enjoy!"];
        
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
    [FFFacebook logInViaFacebookWithSuccessHandler:^(User *user){
        [User setCurrentUser:user];
        [[NSNotificationCenter defaultCenter] postNotificationName:FFUserDidLogInNotification object:user];
    } failure:^(NSError *error, NSHTTPURLResponse *response){
        // Finish registering them
        if (response.statusCode == 404) {
            [SVProgressHUD showWithStatus:@"Loading Facebook Data" maskType:SVProgressHUDMaskTypeGradient];
            
            [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *conn, id result, NSError *err){
                User *user = (User *)self.form.object;
                user.email = result[@"email"];
                user.name = result[@"name"];
                user.fbToken = [FBSession activeSession].accessTokenData.accessToken;
                user.fbTokenExpiresAt = [FBSession activeSession].accessTokenData.expirationDate;
                user.fbTokenRefreshedAt = [FBSession activeSession].accessTokenData.refreshDate;
                
                self.form = [FFForm formForObject:user withFields:[self formFields]];
                
                self.tableView.tableHeaderView = nil;
                
                [self.tableView reloadData];
                
                [SVProgressHUD dismiss];
            }];
        }
    }];
}

@end
