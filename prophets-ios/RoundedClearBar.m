//
//  RoundedClearBar.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/13/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "RoundedClearBar.h"
#import "Utilities.h"
#import "UIColor+Additions.h"
#import "ClearButton.h"

@implementation RoundedClearBar

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

-(id)initWithTitle:(NSString *)title{
    self = [super initWithFrame:CGRectMake(0, 0, 303, 40)];
    if(self){
        [self setupViews];
        [self setTitle:title];
    }
    return self;
}

-(void)setupViews{
    UIEdgeInsets insets = UIEdgeInsetsMake(6, 6, 0, 6);
    UIImage *image = [[UIImage imageNamed:@"clear_bar_rounded.png"] resizableImageWithCapInsets:insets];
    
    UIImageView *barBackground = [[UIImageView alloc] initWithImage:image];
    barBackground.frame = self.frame;
    
    self.leftButton = [[ClearButton alloc] initWithFrame:CGRectMake(8, 5, 56, 30)];
    [self.leftButton setTitle:@"Cancel" forState:UIControlStateNormal];
    
    CGFloat left = self.leftButton.frame.origin.x + self.leftButton.frame.size.width + 8;
    self.titleContainer = [[UIView alloc] initWithFrame:CGRectMake(left, 0,
                                                                   self.frame.size.width - left,
                                                                   self.frame.size.height)];
    
    UIImageView *shield = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_p_small.png"]];
    shield.frame = SameSizeRectAt(0, 4, shield.frame);
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(33, 4, self.titleContainer.frame.size.width - 34, 31)];
    
    self.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:22];
    self.titleLabel.textColor = [UIColor blueGrayColor];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.minimumScaleFactor = 0.5;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    
    [self.titleContainer addSubview:shield];
    [self.titleContainer addSubview:self.titleLabel];
    
    [self addSubview:self.leftButton];
    [self addSubview:barBackground];
    [self addSubview:self.titleContainer];
}

-(void)setTitle:(NSString *)title{
    CGFloat left = self.leftButton.frame.origin.x + self.leftButton.frame.size.width + 5;
    
    self.titleContainer.frame = CGRectMake(left, 0,
                                           self.frame.size.width - left,
                                           self.frame.size.height);
    
    self.titleLabel.frame = CGRectMake(33, 4, self.titleContainer.frame.size.width - 34, 31);
    
    self.titleLabel.text = title;
    
    [self.titleLabel sizeToFit];
    
    self.titleContainer.frame = CGRectMake(left, 0,
                                           self.titleLabel.frame.size.width + 34,
                                           self.frame.size.height);
    
    if (self.titleContainer.center.x < self.center.x) {
        self.titleContainer.center = CGPointMake(self.center.x, self.titleContainer.center.y);
    }
    
}

@end
