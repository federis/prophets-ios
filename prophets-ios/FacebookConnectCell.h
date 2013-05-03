//
//  FacebookConnectCell.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 4/30/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import "FFFormFieldCell.h"
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookConnectCell : FFFormFieldCell

@property (weak, nonatomic) IBOutlet UILabel *connectLabel;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePicture;

- (IBAction)buttonTouched:(id)sender;

@end
