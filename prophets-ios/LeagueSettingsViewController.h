//
//  LeagueSettingsViewController.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/2/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFFormViewController.h"

@class Membership;

@interface LeagueSettingsViewController : FFFormViewController

@property (nonatomic, strong) Membership *membership;

@end
