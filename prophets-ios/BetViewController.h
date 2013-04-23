//
//  BetViewController.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 4/22/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import "FFBaseTableViewController.h"

@class Membership, Bet, BetCell, CommentCell, CommentsController;

@interface BetViewController : FFBaseTableViewController

@property (nonatomic, strong) NSNumber *betId;
@property (nonatomic, strong) Bet *bet;
@property (nonatomic, strong) Membership *membership;
@property (nonatomic, strong) BetCell *measuringCell;
@property (nonatomic, strong) CommentCell *commentMeasuringCell;

@property (nonatomic, strong) CommentsController *commentsController;

@end
