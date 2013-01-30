//
//  LeaderCell.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 1/26/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import "LeaderCell.h"
#import "Membership.h"

@implementation LeaderCell

-(void)setMembership:(Membership *)membership{
    _membership = membership;
    self.valueLabel.text = membership.totalWorth.currencyString;
    self.userNameLabel.text = membership.userName;
    self.rankLabel.text = [membership.leaderboardRank stringValue];
}


@end
