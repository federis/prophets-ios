//
//  LeaguePerformanceView.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/3/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "LeaguePerformanceView.h"
#import "Membership.h"
#import "League.h"

@implementation LeaguePerformanceView

- (id)initWithFrame:(CGRect)frame{
    self = [self init];
    [self setFrame:frame];
    return self;
}

-(id)init{
    NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                          owner:nil
                                                        options:nil];
    
    if ([arrayOfViews count] < 1) return nil;
    
    self = [arrayOfViews objectAtIndex:0];
    
    return self;
}

-(void)setMembership:(Membership *)membership{
    self.availableBalanceLabel.text = membership.balance.currencyString;
    self.commitedToBetsLabel.text = membership.outstandingBetsValue.currencyString;
    self.totalWorthLabel.text = membership.totalWorth.currencyString;
    
    self.rankLabel.text = membership.rank.stringValue;
    self.rankOutOfLabel.text = [NSString stringWithFormat:@"out of %@", membership.league.membershipsCount];
    self.rankBackground.layer.cornerRadius = 3;
}

@end
