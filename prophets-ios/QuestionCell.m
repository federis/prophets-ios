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
                              self.question.betCount,
                              [Utilities pluralize:self.question.betCount
                                          singular:@"bet" plural:@"bets"],
                              self.question.commentCount,
                              [Utilities pluralize:self.question.commentCount
                                          singular:@"comment" plural:@"comments"]];
}

-(CGFloat)heightForCellWithQuestion:(Question *)question{
    CGFloat contentHeight = [Utilities heightForString:question.content
                                                 withFont:self.contentLabel.font
                                                    width:self.contentLabel.frame.size.width];
    return contentHeight + 45;
}

@end
