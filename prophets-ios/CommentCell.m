//
//  CommentCell.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/2/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "CommentCell.h"
#import "Comment.h"
#import "Utilities.h"

@implementation CommentCell

-(void)setComment:(Comment *)comment{
    self.commentContentLabel.text = comment.comment;
    self.commentContentLabel.frame = RectWithNewHeight([Utilities heightForString:comment.comment
                                                                         withFont:self.commentContentLabel.font
                                                                            width:self.commentContentLabel.frame.size.width],
                                                       self.commentContentLabel.frame);
    self.userNameLabel.text = comment.userName;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yy hh:mma";
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    
    self.createdAtLabel.text = [dateFormatter stringFromDate:comment.createdAt];
}

-(CGFloat)heightForCellWithComment:(Comment *)comment{
    return 40 + [Utilities heightForString:comment.comment
                                  withFont:self.commentContentLabel.font
                                     width:self.commentContentLabel.frame.size.width];
}

@end
