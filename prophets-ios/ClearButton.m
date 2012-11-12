//
//  ClearButton.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/12/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "ClearButton.h"

@implementation ClearButton

- (id)initWithFrame:(CGRect)frame{
    self = [self init];
    [self setFrame:frame];
    return self;
}

-(id)init{
    NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                          owner:nil
                                                        options:nil];
    
    if ([arrayOfViews count] < 1) return nil;
    
    self = [arrayOfViews objectAtIndex:0];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(4, 5, 4, 5);
    UIImage *buttonImage = [[UIImage imageNamed:@"clear_button_insets.png"] resizableImageWithCapInsets:insets];
    
    [self setBackgroundImage:buttonImage forState:UIControlStateNormal];
    
    return self;
}

@end
