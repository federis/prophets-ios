//
//  LoginTests.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/3/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFApplicationTest.h"
#import "LoginViewController.h"
#import "FFFormTextField.h"
#import "FFTextFieldCell.h"
#import "FFTableFooterButtonView.h"
#import "User.h"

@interface LoginTests : FFApplicationTest

@property (nonatomic, strong) LoginViewController *loginVC;

@end


@implementation LoginTests
/*
-(void)setUp{
    [super setUp];
    
    self.loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.loginVC loadView];
    [self.loginVC viewDidLoad];
    [self.loginVC.tableView reloadData];
}

-(void)tearDown{
    [super tearDown];
    
    self.loginVC = nil;
}

-(void)testLogin{
    NSURL *url = [NSURL URLWithString:@"tokens" relativeToURL:[RKObjectManager sharedManager].baseURL];
    [RKTestHelpers cacheResponseForURL:url HTTPMethod:@"POST" headers:nil withData:[RKTestFixture dataWithContentsOfFixture:@"user.json"]];
    STAssertNil([User currentUser], @"Current user should be nil");
    
    FFTextFieldCell *emailCell = (FFTextFieldCell *)[self.loginVC.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    FFTextFieldCell *pwCell = (FFTextFieldCell *)[self.loginVC.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    emailCell.textField.text = @"test@example.com";
    pwCell.textField.text = @"password";
    
    [RKTestNotificationObserver waitForNotificationWithName:RKObjectRequestOperationDidFinishNotification usingBlock:^{
        [self.loginVC.footerView.button sendActionsForControlEvents:UIControlEventTouchUpInside];
    }];
    
    STAssertNotNil([User currentUser], @"Current user should not be nil");
}
*/


@end
