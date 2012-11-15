//
//  LeagueFormViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/2/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <SVProgressHUD.h>

#import "LeagueFormViewController.h"
#import "League.h"
#import "RoundedClearBar.h"

@interface LeagueFormViewController ()

@end

@implementation LeagueFormViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    RoundedClearBar *bar = [[RoundedClearBar alloc] initWithTitle:@"Create a League"];
    [bar.leftButton addTarget:self action:@selector(cancelTouched) forControlEvents:UIControlEventTouchUpInside];
    self.fixedHeaderView = bar;
}

-(void)cancelTouched{
    [self dismissViewControllerAnimated:YES completion:^{}];
}


-(void)prepareForm{
    League *league = [League object];
    self.formObject = league;
    
    FFFormTextField *nameField = [FFFormTextField formFieldWithAttributeName:@"name"];
    nameField.returnKeyType = UIReturnKeyNext;
    
    FFFormSwitchField *privateField = [FFFormSwitchField formFieldWithAttributeName:@"priv" labelName:@"Private"];
    
    self.formFields = @[nameField, privateField];
    
    self.submitButtonText = @"Create";
}

-(void)submit{
    [SVProgressHUD showWithStatus:@"Creating league" maskType:SVProgressHUDMaskTypeGradient];
    
    [[RKObjectManager sharedManager] postObject:self.formObject path:@"/leagues" parameters:nil
    success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"League created"];
        DLog(@"%@", mappingResult);
        //League *league = (League *)self.formObject;
        // Take them to the league?
        
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
    failure:^(RKObjectRequestOperation *operation, NSError *error){
        [SVProgressHUD dismiss];
        
        [SVProgressHUD showErrorWithStatus:[error description]];
        
        DLog(@"%@", [error description]);
    }];
}

-(BOOL)formIsValid{
    self.errors = [NSMutableArray array];
    
    for (FFFormField *field in self.formFields) {
        if ([field.attributeName isEqualToString:@"name"]) {
            if (!field.currentValue || [field.currentValue isEqualToString:@""]) {
                [self.errors addObject:@"Name cannot be blank"];
            }
        }
    }
    
    
    return [self.errors count] == 0;
}

-(void)dealloc{
    League *league = (League *)self.formObject;
    if (!league.remoteId) {
        [league deleteFromManagedObjectContext];
    }
}


@end
