//
//  ActivityCell.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 4/22/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

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
    
    self.contentLabel.center = CGPointMake(self.contentLabel.center.x, self.contentView.center.y);
    
    self.commentsLabel.text = [NSString stringWithFormat:@"%@", activity.commentsCount];
    
    self.commentsLabel.center = CGPointMake(self.commentsLabel.center.x, self.contentLabel.center.y-1);
    self.commentsImageView.center = CGPointMake(self.commentsImageView.center.x, self.contentLabel.center.y+2);
}

-(CGFloat)heightForCellWithActivity:(Activity *)activity{
    CGFloat contentHeight = [Utilities heightForString:activity.content
                                              withFont:self.contentLabel.font
                                                 width:self.contentLabel.frame.size.width];
    return contentHeight + 20;
}


@end
