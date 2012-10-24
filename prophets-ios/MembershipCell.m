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
#import "NSDecimalNumber+Additions.h"

@implementation MembershipCell

-(void)setMembership:(Membership *)membership{
    _membership = membership;
    self.leagueNameLabel.text = membership.league.name;
    self.balanceLabel.text = membership.balance.currencyString;
}

@end
