//
//  NSDecimalNumber+Additions.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/3/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDecimalNumber (Additions)

-(NSString *)currencyString;
-(NSDecimalNumber *)decimalNumberByRoundingToTwoDecimalPlaces;
+(NSDecimalNumber *)decimalNumberWithTwoDecimalPlacesFromFloat:(CGFloat)num;

@end
