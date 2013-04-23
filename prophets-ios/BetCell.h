//
//  BetCell.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/29/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFBaseCell.h"

@class Bet;

@interface BetCell : FFBaseCell

@property (nonatomic, strong) Bet *bet;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIView *statusDot;

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet UILabel *betInfoLabel;

@property (weak, nonatomic) IBOutlet UIView *payoutLabelBackground;
@property (weak, nonatomic) IBOutlet UILabel *payoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *payoutSubtextLabel;

@property (weak, nonatomic) IBOutlet UILabel *betSubmittedLabel;
@property (weak, nonatomic) IBOutlet UILabel *bettingEndLabel;
@property (weak, nonatomic) IBOutlet UILabel *loadingBetLabel;


-(CGFloat)heightForCellWithBet:(Bet *)bet;

@end
