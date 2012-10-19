//
//  LoginViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/21/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <RestKit/RestKit.h>

#import "LoginViewController.h"
#import "FFFormField.h"
#import "User.h"
#import "NSManagedObject+Additions.h"
#import "FFApplicationConstants.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.showsPullToRefresh = YES;
    
    User *user = [User object];
    self.formObject = user;
    self.formFields = @[
        [FFFormField formFieldWithAttributeName:@"email" type:FFFormFieldTypeTextField secure:NO],
        [FFFormField formFieldWithAttributeName:@"password" type:FFFormFieldTypeTextField secure:YES]
    ];
    
    self.submitButtonText = @"Sign In";
}

-(void)submit{
    [[RKObjectManager sharedManager] postObject:self.formObject path:@"/tokens" parameters:nil
    success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
        DLog(@"result was %@", mappingResult);
        User *user = (User *)self.formObject;
        [User setCurrentUser:user];
        [[NSNotificationCenter defaultCenter] postNotificationName:FFUserDidLogInNotification object:user];
    }
    failure:^(RKObjectRequestOperation *operation, NSError *error){
        DLog(@"%@", error);
    }];
}

@end
