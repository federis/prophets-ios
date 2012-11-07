//
//  BetViewController.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/3/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFBaseTableViewController.h"

@class Answer, Membership, CreateBetView;

@interface BetViewController : FFBaseTableViewController

@property (nonatomic, strong) CreateBetView *createBetView;
@property (nonatomic, strong) Answer *answer;
@property (nonatomic, strong) Membership *membership;

@end
