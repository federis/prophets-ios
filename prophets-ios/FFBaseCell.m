//
//  FFBaseCell.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/10/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFBaseCell.h"

@implementation FFBaseCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorWithRed:252.0/255.0
                                           green:249.0/255.0
                                            blue:228.0/255.0
                                           alpha:1.0];
}

@end
