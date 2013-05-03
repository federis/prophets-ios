//
//  FacebookConnectCell.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 4/30/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "FacebookConnectCell.h"
#import "FFFacebook.h"
#import "User.h"

@implementation FacebookConnectCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.profilePicture.layer.cornerRadius = 4;
}

-(void)setFormField:(FFFormField *)formField{
    [super setFormField:formField];
    
    if(!formField.currentValue || [formField.currentValue isEqualToString:@""]){
        self.profilePicture.hidden = YES;
        self.connectLabel.text = @"Connect Account";
    }
    else{
        self.profilePicture.profileID = [User currentUser].fbUid;
        self.profilePicture.hidden = NO;
        self.connectLabel.text = @"Disconnect Account";
    }
}

- (IBAction)buttonTouched:(id)sender {
    if(!self.formField.currentValue || [self.formField.currentValue isEqualToString:@""]){
        
        [FFFacebook connectAccountForCurrentUser:^{
            self.profilePicture.profileID = [User currentUser].fbUid;
            self.formField.currentValue = [User currentUser].fbUid;
            self.profilePicture.hidden = NO;
            self.connectLabel.text = @"Disconnect Account";
        } failure:^(NSError *error, NSHTTPURLResponse *response){
            DLog(@"failed to connect account");
        }];
    }
    else{
        self.formField.currentValue = @"";
        self.connectLabel.text = @"Connect Account";
        self.profilePicture.hidden = YES;
    }
}

@end
