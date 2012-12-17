//
//  LeagueDetailCell.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 12/7/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFBaseCell.h"

@class League;

@interface LeagueDetailCell : FFBaseCell

@property (nonatomic, strong) League *league;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *creatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;

-(CGFloat)heightForCellWithLeague:(League *)league;

@end
