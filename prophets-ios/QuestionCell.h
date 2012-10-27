//
//  QuestionCell.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/26/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFBaseCell.h"

@class Question;

@interface QuestionCell : FFBaseCell

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (nonatomic, strong) Question *question;

-(CGFloat)heightForCellWithQuestion:(Question *)question;

@end
