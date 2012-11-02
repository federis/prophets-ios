//
//  CommentCell.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/2/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "CommentCell.h"
#import "Comment.h"

@implementation CommentCell

-(void)setComment:(Comment *)comment{
    self.commentContentLabel.text = comment.comment;
    self.userNameLabel.text = comment.userName;
}

-(CGFloat)heightForCellWithComment:(Comment *)comment{
    return 65;
}

@end
