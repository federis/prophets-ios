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
    CGFloat height = [Utilities heightForString:activity.content
                                       withFont:self.contentLabel.font
                                          width:self.contentLabel.frame.size.width];
    
    self.contentLabel.frame = RectWithNewHeight(height, self.contentLabel.frame);
    
    self.commentsLabel.text = [NSString stringWithFormat:@"%@", activity.commentsCount];
}

-(CGFloat)heightForCellWithActivity:(Activity *)activity{
    CGFloat contentHeight = [Utilities heightForString:activity.content
                                              withFont:self.contentLabel.font
                                                 width:self.contentLabel.frame.size.width];
    return contentHeight + 16;
}


@end
