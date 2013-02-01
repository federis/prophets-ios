//
//  AdminQuestionCell.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 1/31/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import "FFBaseCell.h"
#import "ManageQuestionsViewController.h"

@class Question;

@interface AdminQuestionCell : FFBaseCell

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (nonatomic, strong) Question *question;
@property (nonatomic, assign) FFQuestionScope scope;

@property (weak, nonatomic) IBOutlet UIButton *publishButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *judgeButton;
@property (weak, nonatomic) IBOutlet UIButton *viewButton;

-(CGFloat)heightForCellWithQuestion:(Question *)question;

-(IBAction)publishTouched:(id)sender;
-(IBAction)editTouched:(id)sender;
-(IBAction)deleteTouched:(id)sender;
-(IBAction)judgeTouched:(id)sender;
-(IBAction)viewTouched:(id)sender;

@end
