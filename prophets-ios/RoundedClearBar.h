//
//  RoundedClearBar.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/13/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundedClearBar : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *titleContainer;
@property (nonatomic, strong) UIButton *leftButton;

-(id)initWithTitle:(NSString *)title;
-(void)setTitle:(NSString *)title;

@end
