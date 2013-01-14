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
#import "FFFormSwitchFieldCell.h"

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
    League *league = (League *)[self.scratchContext insertNewObjectForEntityForName:@"League"];
    
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
           NSArray *newTags = [mappingResult array];
           NSMutableArray *tagNames = [NSMutableArray array];
           for (Tag *tag in newTags) {
               [tagNames addObject:tag.name];
           }
           tagField.pickerOptions = tagNames;
       }
       failure:^(RKObjectRequestOperation *operation, NSError *error){
           DLog(@"Error is %@", error);
       }];
    
    self.form = [FFForm formForObject:league withFields:@[nameField, privateField, tagField]];
    self.form.delegate = self;
    
    self.submitButtonText = @"Create";
}


-(void)tableCell:(UITableViewCell *)cell loadedField:(FFFormField *)field{
    if ([field.attributeName isEqualToString:@"priv"]) {
        FFFormSwitchFieldCell *switchCell = (FFFormSwitchFieldCell *)cell;
        [switchCell.switchControl addTarget:self action:@selector(privateFieldSwitched:) forControlEvents:UIControlEventValueChanged];
    }
}

-(void)submit{
    [SVProgressHUD showWithStatus:@"Creating league" maskType:SVProgressHUDMaskTypeGradient];
    
    [[RKObjectManager sharedManager] postObject:self.form.object path:@"/leagues" parameters:nil
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
        
        ErrorCollection *errors = [[[error userInfo] objectForKey:RKObjectMapperErrorObjectsKey] lastObject];
        [SVProgressHUD showErrorWithStatus:[errors messagesString]];
        
        DLog(@"%@", [error description]);
    }];
}

-(BOOL)formIsValid{
    self.errors = [NSMutableArray array];
    
    for (FFFormField *field in self.form.fields) {
        if ([field.attributeName isEqualToString:@"name"]) {
            if (!field.currentValue || [field.currentValue isEqualToString:@""]) {
                [self.errors addObject:@"Name cannot be blank"];
            }
        }
    }
    
    
    return [self.errors count] == 0;
}

-(void)privateFieldSwitched:(id)sender{
    UISwitch *switchControl = (UISwitch *)sender;
    if(switchControl.isOn){
        FFFormTextField *passwordField = [FFFormTextField formFieldWithAttributeName:@"password"];
        passwordField.returnKeyType = UIReturnKeyNext;
        passwordField.secure = YES;
        [self.form insertFormField:passwordField atRow:2];
    }
    else{
        [self.form removeFormFieldAtRow:2];
    }
}

@end
