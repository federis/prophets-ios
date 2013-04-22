//
//  ActivityCell.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 4/22/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import "ActivityCell.h"
#import "Activity.h"
#import "Utilities.h"

@implementation ActivityCell

-(void)setActivity:(Activity *)activity{
    _activity = activity;
    self.contentLabel.text = activity.content;
    self.contentLabel.frame = RectWithNewHeight([Utilities heightForString:activity.content
                                                                  withFont:self.contentLabel.font
                                                                     width:self.contentLabel.frame.size.width], self.contentLabel.frame);
    NSString *commentsTitle = [NSString stringWithFormat:@"%@ %@",
                               activity.commentsCount,
                               [Utilities pluralize:activity.commentsCount singular:@"comment" plural:@"comments"]];
    
    self.commentsLabel.text = commentsTitle;
}

-(CGFloat)heightForCellWithActivity:(Activity *)activity{
    CGFloat contentHeight = [Utilities heightForString:activity.content
                                              withFont:self.contentLabel.font
                                                 width:self.contentLabel.frame.size.width];
    return contentHeight + 45;
}


@end
