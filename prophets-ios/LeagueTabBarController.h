//
//  LeagueTabBarController.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/22/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class League, Membership;

@interface LeagueTabBarController : UITabBarController

@property (nonatomic, strong) Membership *membership;

@end
