//
//  NSNumber+Additions.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/3/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "NSNumber+Additions.h"

@implementation NSNumber (Additions)

-(NSString *)currencyString{
    return [NSString stringWithFormat:@"%@\u01A4", self];
}

@end
