//
//  ActivityCell.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 4/22/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import "FFBaseCell.h"

@class Activity;

@interface ActivityCell : UITableViewCell

@property (nonatomic, strong) Activity *activity;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *commentsImageView;

-(CGFloat)heightForCellWithActivity:(Activity *)activity;

@end
