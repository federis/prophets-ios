//
//  FFFormTextArea.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/12/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFFormTextViewField.h"

@implementation FFFormTextViewField

-(CGFloat)height{
    if (_height) {
        return _height;
    }
    return 130;
}

@end
