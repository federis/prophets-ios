//
//  FFFormDateField.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/13/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFFormDateField.h"

@implementation FFFormDateField

-(id)currentValue{
    if (![super currentValue]) {
        return self.initialDate;
    }
    
    return [super currentValue];
}

@end
