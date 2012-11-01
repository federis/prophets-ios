//
//  MembershipCell.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/30/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <RestKit/RestKit.h>

#import "MembershipCell.h"
#import "League.h"
#import "Utilities.h"

@implementation MembershipCell

-(void)setMembership:(Membership *)membership{
    _membership = membership;
    self.leagueNameLabel.text = membership.league.name;
    self.memberCountLabel.text = [NSString stringWithFormat:@"%@ %@", membership.league.membershipsCount, [Utilities pluralize:membership.league.membershipsCount
                                                                                                                      singular:@"member"
                                                                                                                        plural:@"members"]];
    
    [self layoutLabels];
}

-(void)layoutLabels{
    CGFloat leagueNameHeight = [Utilities heightForString:self.leagueNameLabel.text
                                                 withFont:self.leagueNameLabel.font
                                                    width:self.leagueNameLabel.frame.size.width];
    
    self.leagueNameLabel.frame = CGRectMake(self.leagueNameLabel.frame.origin.x,
                                            self.leagueNameLabel.frame.origin.y,
                                            self.leagueNameLabel.frame.size.width,
                                            leagueNameHeight);
    
    self.memberCountLabel.frame = CGRectMake(self.memberCountLabel.frame.origin.x,
                                             self.leagueNameLabel.frame.origin.y + leagueNameHeight,
                                             self.memberCountLabel.frame.size.width,
                                             self.memberCountLabel.frame.size.height);
}

-(CGFloat)heightForCellWithMembership:(Membership *)membership{
    CGFloat leagueNameHeight = [Utilities heightForString:membership.league.name
                                                 withFont:self.leagueNameLabel.font
                                                    width:self.leagueNameLabel.frame.size.width];
    return leagueNameHeight + 45;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.showsAccessoryView = YES;
}

@end
