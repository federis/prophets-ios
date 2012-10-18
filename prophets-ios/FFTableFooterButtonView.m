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



@implementation FFTableFooterButtonView

+(FFTableFooterButtonView *)footerButtonViewForTable:(UITableView *)tableView withText:(NSString *)text{
    return [[FFTableFooterButtonView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50) text:text];
}

-(id)initWithFrame:(CGRect)frame text:(NSString *)text{
    self = [super initWithFrame:frame];
    if(self){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIEdgeInsets insets = UIEdgeInsetsMake(14, 5, 14, 5);
        UIImage *buttonImage = [[UIImage imageNamed:@"red_footer_button.png"] resizableImageWithCapInsets:insets];
        
        [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [button setTitle:text forState:UIControlStateNormal];
        [button setTitleColor:[UIColor creamColor] forState:UIControlStateNormal];
        [button setTitleShadowColor:[UIColor colorWithRed:93.0/255.0 green:33.0/255.0 blue:0.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        button.titleLabel.shadowOffset = CGSizeMake(0, -1);
        button.titleLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:14];
        
        CGSize buttonSize = [text sizeWithFont:button.titleLabel.font];
        buttonSize.width += 50; // add padding
        button.frame = CGRectMake(frame.size.width - buttonSize.width - 25, 0, buttonSize.width, 28);
        
        [button.layer setShadowOffset:CGSizeMake(1, 1)];
        [button.layer setShadowOpacity:0.5];
        [button.layer setShadowRadius:2];
        [button.layer setShadowColor:[[UIColor blackColor] CGColor]];
        
        [self addSubview:button];
    }
    return self;
}

-(void)didMoveToSuperview{
    [self.superview sendSubviewToBack:self]; //so that the button appears behind cell shadows
}

@end
