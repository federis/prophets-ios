//
//  QuestionCell.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/26/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "QuestionCell.h"
#import "Question.h"
#import "Utilities.h"

@implementation QuestionCell

-(void)setQuestion:(Question *)question{
    _question = question;
    self.contentLabel.text = question.content;
}

-(CGFloat)heightForCellWithQuestion:(Question *)question{
    CGFloat contentHeight = [Utilities heightForString:question.content
                                                 withFont:self.contentLabel.font
                                                    width:self.contentLabel.frame.size.width];
    return contentHeight + 45;
}

@end
