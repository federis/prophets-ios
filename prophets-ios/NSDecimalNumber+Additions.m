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
    return [NSString stringWithFormat:@"%@\u01A4", [self decimalNumberByRoundingToTwoDecimalPlaces]];
}

-(NSDecimalNumber *)decimalNumberByRoundingToTwoDecimalPlaces{
    NSDecimalNumberHandler *behavior = [NSDecimalNumberHandler
                                        decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                        scale:2
                                        raiseOnExactness:YES
                                        raiseOnOverflow:YES
                                        raiseOnUnderflow:YES
                                        raiseOnDivideByZero:YES];
    
    return [self decimalNumberByRoundingAccordingToBehavior:behavior];
}

+(NSDecimalNumber *)decimalNumberWithTwoDecimalPlacesFromFloat:(CGFloat)num{
    NSDecimalNumberHandler *behavior = [NSDecimalNumberHandler
                                        decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                       scale:2
                                                            raiseOnExactness:YES
                                                             raiseOnOverflow:YES
                                                            raiseOnUnderflow:YES
                                                         raiseOnDivideByZero:YES];
    
    NSDecimalNumber *decimalNum = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithFloat:num] decimalValue]];
    
    return [decimalNum decimalNumberByRoundingAccordingToBehavior:behavior];
}

@end
