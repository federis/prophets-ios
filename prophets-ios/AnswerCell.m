//
//  AnswerCell.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/3/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "AnswerCell.h"
#import "Answer.h"

@implementation AnswerCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.showsAccessoryView = YES;
}

-(void)setAnswer:(Answer *)answer{
    self.answerLabel.text = answer.content;
}

-(CGFloat)heightForCellWithAnswer:(Answer *)answer{
    return 50;
}

@end
