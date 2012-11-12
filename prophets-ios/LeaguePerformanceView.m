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
    
    if (_membership) {
        [self removeObserverRegistrations];
    }
    
    _membership = membership;
    
    self.availableBalanceLabel.text = membership.balance.currencyString;
    self.commitedToBetsLabel.text = membership.outstandingBetsValue.currencyString;
    self.totalWorthLabel.text = membership.totalWorth.currencyString;
    
    self.rankLabel.text = membership.rank.stringValue;
    self.rankOutOfLabel.text = [NSString stringWithFormat:@"out of %@", membership.league.membershipsCount];
    self.rankBackground.layer.cornerRadius = 3;
    
    [membership addObserver:self forKeyPath:@"balance" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)  context:nil];
    [membership addObserver:self forKeyPath:@"outstandingBetsValue" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)  context:nil];
    [membership addObserver:self forKeyPath:@"rank" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)  context:nil];
    [membership addObserver:self forKeyPath:@"league.membershipsCount" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)  context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([object isKindOfClass:[Membership class]] &&
        ![[change objectForKey:NSKeyValueChangeNewKey] isEqual:[change objectForKey:NSKeyValueChangeOldKey]]) {
        
        if([keyPath isEqual:@"balance"]){
            self.availableBalanceLabel.text = self.membership.balance.currencyString;
            self.totalWorthLabel.text = self.membership.totalWorth.currencyString;
        }
        else if([keyPath isEqual:@"outstandingBetsValue"]){
            self.commitedToBetsLabel.text = self.membership.outstandingBetsValue.currencyString;
            self.totalWorthLabel.text = self.membership.totalWorth.currencyString;
        }
        else if([keyPath isEqual:@"rank"]){
            self.rankLabel.text = self.membership.rank.stringValue;
        }
        else if([keyPath isEqual:@"league.membershipsCount"]){
            self.rankOutOfLabel.text = [NSString stringWithFormat:@"out of %@", self.membership.league.membershipsCount];
        }
        
    }
}

-(void)removeObserverRegistrations{
    [_membership removeObserver:self forKeyPath:@"balance"];
    [_membership removeObserver:self forKeyPath:@"outstandingBetsValue"];
    [_membership removeObserver:self forKeyPath:@"rank"];
    [_membership removeObserver:self forKeyPath:@"league.membershipsCount"];
}

-(void)dealloc{
    [self removeObserverRegistrations];
}

@end
