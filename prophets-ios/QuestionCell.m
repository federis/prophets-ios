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
    self.detailsLabel.text = [NSString stringWithFormat:@"%@ %@ · %@ %@",
                              self.question.betsCount,
                              [Utilities pluralize:self.question.betsCount
                                          singular:@"bet" plural:@"bets"],
                              self.question.commentsCount,
                              [Utilities pluralize:self.question.commentsCount
                                          singular:@"comment" plural:@"comments"]];
    
    [self layoutLabels];
}

-(void)layoutLabels{
    CGFloat contentHeight = [Utilities heightForString:self.contentLabel.text
                                              withFont:self.contentLabel.font
                                                 width:self.contentLabel.frame.size.width];
    
    self.contentLabel.frame = SameOriginRectWithSize(self.contentLabel.frame.size.width, contentHeight, self.contentLabel.frame);
    
    self.detailsLabel.frame = RectBelowRectWithSpacingAndSize(self.contentLabel.frame, 5, self.detailsLabel.frame.size);
}

-(CGFloat)heightForCellWithQuestion:(Question *)question{
    CGFloat contentHeight = [Utilities heightForString:question.content
                                                 withFont:self.contentLabel.font
                                                    width:self.contentLabel.frame.size.width];
    return contentHeight + 40;
}

@end
