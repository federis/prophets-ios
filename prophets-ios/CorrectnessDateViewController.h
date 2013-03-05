//
//  CorrectnessDateViewController.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 3/4/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import "FFBaseViewController.h"

@class Answer;

@interface CorrectnessDateViewController : FFBaseViewController

@property (nonatomic, strong) Answer *answer;

@property (nonatomic, weak) IBOutlet UITextField *correctnessDateField;
@property (nonatomic, weak) IBOutlet UIButton *saveButton;

-(IBAction)segmentControlChanged:(id)sender;
-(IBAction)saveTouched:(id)sender;

@end
