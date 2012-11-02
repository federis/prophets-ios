//
//  NSDecimalNumber+Additions.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/3/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "NSDecimalNumber+Additions.h"

@implementation NSDecimalNumber (Additions)

-(NSString *)currencyString{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    return [numberFormatter stringFromNumber:self];
}

@end
