//
//  LeagueCell.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 12/2/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "LeagueCell.h"
#import "League.h"

@implementation LeagueCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.showsAccessoryView = YES;
}

-(void)setLeague:(League *)league{
    _league = league;
    self.nameLabel.text = league.name;
}

-(CGFloat)heightForCellWithLeague:(League *)league{
    return 44;
}

@end
