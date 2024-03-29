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
#import "FFDeepLinker.h"
#import "FFFacebook.h"

@interface LeagueFormViewController ()

@end

@implementation LeagueFormViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.facebookSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(20, 3, 0, 0)];
    self.facebookSwitch.onImage = [UIImage imageNamed:@"facebook-switch-on.png"];
    self.facebookSwitch.offImage = [UIImage imageNamed:@"facebook-switch-off.png"];
    
    if(self.league.isNew){
        RoundedClearBar *bar = [[RoundedClearBar alloc] initWithTitle:@"Create a League"];
        [bar.leftButton addTarget:self action:@selector(cancelTouched) forControlEvents:UIControlEventTouchUpInside];
        self.fixedHeaderView = bar;
    }
}

-(void)cancelTouched{
    [self dismissViewControllerAnimated:YES completion:^{}];
}


-(void)prepareForm{
    if (!self.league) {
        self.league = (League *)[self.scratchContext insertNewObjectForEntityForName:@"League"];
    }
    
    FFFormTextField *nameField = [FFFormTextField formFieldWithAttributeName:@"name"];
    nameField.returnKeyType = UIReturnKeyNext;
    
    //FFFormSwitchField *privateField = [FFFormSwitchField formFieldWithAttributeName:@"priv" labelName:@"Private"];
    
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
    [tagNames addObject:@""];
    for (Tag *tag in tags) {
        [tagNames addObject:tag.name];
    }
    tagField.pickerOptions = tagNames;
    
    [[RKObjectManager sharedManager] getObjectsAtPathForRouteNamed:@"tags" object:nil parameters:nil
       success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
           DLog(@"Result is %@", mappingResult);
           NSArray *newTags = [mappingResult array];
           NSMutableArray *tagNames = [NSMutableArray array];
           [tagNames addObject:@""];
           for (Tag *tag in newTags) {
               [tagNames addObject:tag.name];
           }
           tagField.pickerOptions = tagNames;
       }
       failure:^(RKObjectRequestOperation *operation, NSError *error){
           DLog(@"Error is %@", error);
       }];
    
    self.form = [FFForm formForObject:self.league withFields:@[nameField, tagField]];
    self.form.delegate = self;
    
    self.submitButtonText = self.league.isNew ? @"Create" : @"Save";
}


-(void)tableCell:(UITableViewCell *)cell loadedField:(FFFormField *)field{
    if ([field.attributeName isEqualToString:@"priv"]) {
        FFFormSwitchFieldCell *switchCell = (FFFormSwitchFieldCell *)cell;
        [switchCell.switchControl addTarget:self action:@selector(privateFieldSwitched:) forControlEvents:UIControlEventValueChanged];
    }
}

-(void)submit{
    [SVProgressHUD showWithStatus:@"Creating league" maskType:SVProgressHUDMaskTypeGradient];
    
    if (self.league.isNew) {
        [[RKObjectManager sharedManager] postObject:self.form.object path:@"/leagues" parameters:nil
            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
                [SVProgressHUD dismiss];
                [SVProgressHUD showSuccessWithStatus:@"League created"];
                DLog(@"%@", mappingResult);
                
                NSManagedObjectContext *context = [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
                League *l = (League *)[context objectWithID:self.league.objectID];
                
                [self dismissViewControllerAnimated:YES completion:^{
                    [[FFDeepLinker sharedLinker] showLeague:l selectedTabIndex:0];
                }];
                
                if (self.facebookSwitch.isOn) {
                    [self publishLeagueToFacebook:l];
                }
            }
            failure:^(RKObjectRequestOperation *operation, NSError *error){
                [SVProgressHUD dismiss];
                
                ErrorCollection *errors = [[[error userInfo] objectForKey:RKObjectMapperErrorObjectsKey] lastObject];
                [SVProgressHUD showErrorWithStatus:[errors messagesString]];
                
                DLog(@"%@", [error description]);
            }];
    }
    else{
        [[RKObjectManager sharedManager] putObject:self.form.object path:nil parameters:nil
            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
                [SVProgressHUD dismiss];
                [SVProgressHUD showSuccessWithStatus:@"League updated"];
                DLog(@"%@", mappingResult);
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            failure:^(RKObjectRequestOperation *operation, NSError *error){
                [SVProgressHUD dismiss];
                
                ErrorCollection *errors = [[[error userInfo] objectForKey:RKObjectMapperErrorObjectsKey] lastObject];
                [SVProgressHUD showErrorWithStatus:[errors messagesString]];
                
                DLog(@"%@", [error description]);
            }];
    }
}

-(void)publishLeagueToFacebook:(League *)league{
    NSString *text = [NSString stringWithFormat:@"I created the league \"%@\" on 55Prophets", league.name];
    
    NSDictionary *params = @{
                             @"name" : text,
                             @"picture" : @"http://55prophets.com/images/55_logo_for_facebook_stories.png",
                             @"ref" : @"CreateLeague",
                             @"link" : @"http://55prophets.com",
                             @"app_id" : [FBSettings defaultAppID]
                             };
    
    [FBWebDialogs presentFeedDialogModallyWithSession:nil parameters:params handler:
     ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         
     }];
}

-(BOOL)formIsValid{
    self.errors = [NSMutableArray array];
    
    for (FFFormSection *section in self.form.sections){
        for (FFFormField *field in section.fields) {
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
            
            if ([field.attributeName isEqualToString:@"tagList"]) {
                if (!field.currentValue || [field.currentValue isEqualToString:@""]) {
                    [self.errors addObject:@"Category cannot be blank"];
                }
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

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [super tableView:tableView viewForFooterInSection:section];
    
    [footerView addSubview:self.facebookSwitch];
    
    return footerView;
}


@end
