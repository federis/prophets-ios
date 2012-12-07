//
//  LeagueCell.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 12/2/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFBaseCell.h"

@class League;

@interface LeagueCell : FFBaseCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) League *league;

-(CGFloat)heightForCellWithLeague:(League *)league;

@end
