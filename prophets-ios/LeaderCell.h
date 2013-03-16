//
//  LeaderCell.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 1/26/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import "FFBaseCell.h"

@class Membership;

@interface LeaderCell : FFBaseCell

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;

@property (nonatomic, strong) Membership *membership;

@end
