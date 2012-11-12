//
//  FFLabel.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/12/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFLabel.h"
#import "UIColor+Additions.h"

@implementation FFLabel

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDefaults];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupDefaults];
    }
    return self;
}

-(id)init{
    self = [super init];
    if(self){
        [self setupDefaults];
    }
    return self;
}

-(void)setupDefaults{
    _fontSize = 15;
    _isBold = YES;
    self.textColor = [UIColor creamColor];
    self.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:15];
    self.backgroundColor = [UIColor clearColor];
    self.numberOfLines = 0;
    self.lineBreakMode = NSLineBreakByWordWrapping;
}

-(void)setFontSize:(CGFloat)size{
    _fontSize = size;
    if (self.isBold) {
        self.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:size];
    }
    else{
        self.font = [UIFont fontWithName:@"AvenirNext-Regular" size:size];
    }
}

-(void)setIsBold:(BOOL)isBold{
    _isBold = isBold;
    if (isBold) {
        self.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:self.fontSize];
    }
    else{
        self.font = [UIFont fontWithName:@"AvenirNext-Regular" size:self.fontSize];
    }
}

@end
