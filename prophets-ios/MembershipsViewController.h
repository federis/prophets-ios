//
//  LeagueMembershipsViewController.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/28/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFFetchedResultsViewController.h"

@class MembershipCell;

@interface MembershipsViewController : FFFetchedResultsViewController

@property (nonatomic, strong) MembershipCell *measuringCell;

@end
