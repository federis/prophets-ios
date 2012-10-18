//
//  FFFormViewController.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/11/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFBaseTableViewController.h"

@interface FFFormViewController : FFBaseTableViewController

@property (nonatomic, strong) id formObject;
@property (nonatomic, strong) NSArray *formFields;
@property (nonatomic, strong) NSString *submitButtonText;

-(void)submit;

@end
