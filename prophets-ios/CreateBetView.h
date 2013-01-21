//
//  CreateBetView.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/3/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Answer, Membership, Bet;

@interface CreateBetView : UIView<UITextFieldDelegate>

@property (nonatomic, strong) Answer *answer;
@property (nonatomic, strong) Membership *membership;
@property (nonatomic, strong) Bet *bet;

@property (weak, nonatomic) IBOutlet UILabel *answerNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *betAmountTextField;
@property (weak, nonatomic) IBOutlet UISlider *betAmountSlider;
@property (weak, nonatomic) IBOutlet UILabel *maxBetLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentOddsLabel;
@property (weak, nonatomic) IBOutlet UIButton *explainButton;
@property (weak, nonatomic) IBOutlet UILabel *payoutLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitBetButton;
@property (weak, nonatomic) IBOutlet UIView *submitBetButtonBackground;
@property (weak, nonatomic) IBOutlet UIView *containerView;

-(id)initWithBet:(Bet *)bet inAnswer:(Answer *)answer forMembership:(Membership *)membership;

+(CGFloat)heightForViewWithAnswer:(Answer *)answer;

@end
