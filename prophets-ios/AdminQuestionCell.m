//
//  AdminQuestionCell.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 1/31/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import "AdminQuestionCell.h"
#import "Question.h"
#import "Utilities.h"

@implementation AdminQuestionCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(4, 4, 4, 4);
    
    UIImage *redImage = [[UIImage imageNamed:@"red_button_insets.png"] resizableImageWithCapInsets:insets];
    [self.deleteButton setBackgroundImage:redImage forState:UIControlStateNormal];
    
    UIImage *greenImage = [[UIImage imageNamed:@"green_button_insets.png"] resizableImageWithCapInsets:insets];
    [self.publishButton setBackgroundImage:greenImage forState:UIControlStateNormal];
    
    UIImage *blueImage = [[UIImage imageNamed:@"blue_button_insets.png"] resizableImageWithCapInsets:insets];
    [self.judgeButton setBackgroundImage:blueImage forState:UIControlStateNormal];
    [self.editButton setBackgroundImage:blueImage forState:UIControlStateNormal];
    [self.viewButton setBackgroundImage:blueImage forState:UIControlStateNormal];
}



-(void)setQuestion:(Question *)question{
    _question = question;
    self.contentLabel.text = question.content;
    
    self.contentLabel.frame = RectWithNewHeight([Utilities heightForString:question.content
                                                                  withFont:self.contentLabel.font
                                                                     width:self.contentLabel.frame.size.width], self.contentLabel.frame);
}

-(void)setScope:(FFQuestionScope)scope{
    _scope = scope;
    
    CGFloat y = RectBelowRectWithSpacingAndSize(self.contentLabel.frame, 10, CGSizeMake(10, 10)).origin.y;
    
    if (scope == FFQuestionUnapproved) {
        [Utilities layoutViewsHorizantally:@[ self.publishButton, self.editButton, self.deleteButton ]
                             endingAtPoint:CGPointMake(275, y)];
        
        self.judgeButton.hidden = YES;
        self.viewButton.hidden = YES;
    }
    else if (scope == FFQuestionPendingJudgement){
        [Utilities layoutViewsHorizantally:@[ self.judgeButton ]
                             endingAtPoint:CGPointMake(275, y)];
        
        self.deleteButton.hidden = YES;
        self.viewButton.hidden = YES;
        self.publishButton.hidden = YES;
        self.editButton.hidden = YES;
    }
    else if (scope == FFQuestionComplete){
        [Utilities layoutViewsHorizantally:@[ self.viewButton ]
                             endingAtPoint:CGPointMake(275, y)];
        
        self.deleteButton.hidden = YES;
        self.judgeButton.hidden = YES;
        self.publishButton.hidden = YES;
        self.editButton.hidden = YES;
    }
    else{ //currently running
        [Utilities layoutViewsHorizantally:@[ self.editButton, self.deleteButton, self.judgeButton ]
                             endingAtPoint:CGPointMake(275, y)];
        
        self.viewButton.hidden = YES;
        self.publishButton.hidden = YES;
    }
}

-(CGFloat)heightForCellWithQuestion:(Question *)question{
    CGFloat contentHeight = [Utilities heightForString:question.content
                                              withFont:self.contentLabel.font
                                                 width:self.contentLabel.frame.size.width];
    return contentHeight + 63;
}


@end
