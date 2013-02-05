//
//  AdminMembershipCell.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 2/5/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import "AdminMembershipCell.h"
#import "Membership.h"
#import "User.h"

@implementation AdminMembershipCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(4, 4, 4, 4);
    
    UIImage *redImage = [[UIImage imageNamed:@"red_button_insets.png"] resizableImageWithCapInsets:insets];
    [self.deleteButton setBackgroundImage:redImage forState:UIControlStateNormal];
}

-(void)setMembership:(Membership *)membership{
    _membership = membership;
    
    self.userNameLabel.text = membership.user.name;
    self.emailLabel.text = membership.user.email;
}

@end
