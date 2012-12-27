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
#import "Tag.h"
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
    
    FFFormPickerField *tagField = [FFFormPickerField formFieldWithAttributeName:@"tagList" labelName:@"Category"];
    
    NSURL *url = [[RKObjectManager sharedManager].router URLForRouteNamed:@"tags" method:nil object:nil];
    
    NSFetchRequest *fetchRequest = [RKArrayOfFetchRequestFromBlocksWithURL([RKObjectManager sharedManager].fetchRequestBlocks, url) lastObject];
    NSManagedObjectContext *managedObjectContext = [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
    
    NSError *error = nil;
    NSArray *tags = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
	if(error){
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
    
    NSMutableArray *tagNames = [NSMutableArray array];
    for (Tag *tag in tags) {
        [tagNames addObject:tag.name];
    }
    tagField.pickerOptions = tagNames;
    
    [[RKObjectManager sharedManager] getObjectsAtPathForRouteNamed:@"tags" object:nil parameters:nil
       success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
           DLog(@"Result is %@", mappingResult);
       }
       failure:^(RKObjectRequestOperation *operation, NSError *error){
           DLog(@"Error is %@", error);
       }];
    
    self.formFields = @[nameField, privateField, tagField];
    
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
