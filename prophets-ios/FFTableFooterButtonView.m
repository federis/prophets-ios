//
//  TableFooterButtonView.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/14/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "FFTableFooterButtonView.h"
#import "UIColor+Additions.h"
#import "Utilities.h"



@implementation FFTableFooterButtonView

+(FFTableFooterButtonView *)footerButtonViewForTable:(UITableView *)tableView withText:(NSString *)text{
    return [[FFTableFooterButtonView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50) text:text];
}

-(id)initWithFrame:(CGRect)frame text:(NSString *)text{
    self = [super initWithFrame:frame];
    if(self){
        self.button = [FFTableFooterButtonView footerButtonWithText:text color:@"red"];
        self.button.frame = SameSizeRectAt(frame.size.width - self.button.frame.size.width - 25, 0, self.button.frame);
        [self addSubview:self.button];
        
        UIEdgeInsets insets = UIEdgeInsetsMake(0, 13, 0, 13);
        UIImage *shadowImage = [[UIImage imageNamed:@"table_shadow_insets.png"] resizableImageWithCapInsets:insets];
        UIImageView *shadow = [[UIImageView alloc] initWithImage:shadowImage];
        shadow.frame = CGRectMake(15, -1, frame.size.width - 30, shadowImage.size.height);
        [self addSubview:shadow];
    }
    return self;
}

+(UIButton *)footerButtonWithText:(NSString *)text color:(NSString *)color{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIEdgeInsets insets = UIEdgeInsetsMake(14, 5, 14, 5);
    NSString *imageName = [NSString stringWithFormat:@"%@_footer_button.png", color];
    UIImage *buttonImage = [[UIImage imageNamed:imageName] resizableImageWithCapInsets:insets];
    
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:[UIColor creamColor] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor colorWithRed:93.0/255.0 green:33.0/255.0 blue:0.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    button.titleLabel.shadowOffset = CGSizeMake(0, -1);
    button.titleLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:14];
    
    CGSize buttonSize = [text sizeWithFont:button.titleLabel.font];
    buttonSize.width += 50; // add padding
    
    button.frame = CGRectMake(0, 0, buttonSize.width, 31);
    
    [button.layer setShadowOffset:CGSizeMake(1, 1)];
    [button.layer setShadowOpacity:0.5];
    [button.layer setShadowRadius:2];
    [button.layer setShadowColor:[[UIColor blackColor] CGColor]];
    
    return button;
}

-(void)setLeftButtonText:(NSString *)text{
    if (self.leftButton) {
        [self.leftButton removeFromSuperview];
    }
    
    self.leftButton = [FFTableFooterButtonView footerButtonWithText:text color:@"green"];
    self.leftButton.frame = SameSizeRectAt(25, 0, self.leftButton.frame);
    
    [self addSubview:self.leftButton];
    [self sendSubviewToBack:self.leftButton];
}

-(void)didMoveToSuperview{
    [self.superview sendSubviewToBack:self]; //so that the button appears behind cell shadows
}

@end
