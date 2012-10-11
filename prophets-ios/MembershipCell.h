//
//  MembershipCell.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/30/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFBaseCell.h"

@interface MembershipCell : FFBaseCell

@property (nonatomic, weak) IBOutlet UILabel *leagueNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *balanceLabel;

@end
