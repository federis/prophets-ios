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

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.showsPullToRefresh = YES;
    
    User *user = [User tempObject];
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
    }
    failure:^(RKObjectRequestOperation *operation, NSError *error){
        DLog(@"%@", error);
    }];
    
    
}

@end
