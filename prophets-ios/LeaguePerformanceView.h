//
//  LeaguePerformanceView.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/3/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Membership;

@interface LeaguePerformanceView : UIView

@property (weak, nonatomic) IBOutlet UILabel *availableBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *commitedToBetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalWorthLabel;
@property (weak, nonatomic) IBOutlet UIView *rankBackground;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankOutOfLabel;

@property (nonatomic, strong) Membership *membership;

@end
