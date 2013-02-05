//
//  AdminMembershipCell.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 2/5/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import "FFBaseCell.h"

@class Membership;

@interface AdminMembershipCell : FFBaseCell

@property (nonatomic, strong) Membership *membership;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end
