//
//  Utilities.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/17/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject

+(CGFloat)heightForString:(NSString *)str withFont:(UIFont *)font width:(CGFloat)width;
+(NSString *)pluralize:(NSNumber *)num singular:(NSString *)singular plural:(NSString *)plural;
+ (NSDictionary *)classPropsFor:(Class)klass;

@end
