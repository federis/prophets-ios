//
//  LeagueCell.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 12/2/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "LeagueCell.h"
#import "League.h"
#import "Utilities.h"

@implementation LeagueCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.showsAccessoryView = YES;
}

-(void)setLeague:(League *)league{
    _league = league;
    self.nameLabel.text = league.name;
    self.privateLabel.hidden = !league.priv;
    self.nameLabel.frame = RectWithNewHeight([Utilities heightForString:league.name
                                                                 withFont:self.nameLabel.font
                                                                    width:self.nameLabel.frame.size.width],
                                             self.nameLabel.frame);

}

-(CGFloat)heightForCellWithLeague:(League *)league{
    int pad = league.priv ? 32 : 20;
    return pad + [Utilities heightForString:league.name
                                   withFont:self.nameLabel.font
                                      width:self.nameLabel.frame.size.width];
}

@end
