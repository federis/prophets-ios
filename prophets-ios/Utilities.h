//
//  Utilities.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/17/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject

CGRect SameSizeRectAt(CGFloat x, CGFloat y, CGRect rect);
CGRect SameOriginRectWithSize(CGFloat width, CGFloat height, CGRect rect);
CGRect RectWithNewHeight(CGFloat height, CGRect rect);

+(void)showOkAlertWithError:(NSError *)error;
+(void)showOkAlertWithTitle:(NSString *)title message:(NSString *)message;
+(CGFloat)heightForString:(NSString *)str withFont:(UIFont *)font width:(CGFloat)width;
+(NSString *)pluralize:(NSNumber *)num singular:(NSString *)singular plural:(NSString *)plural;
+ (NSDictionary *)classPropsFor:(Class)klass;

@end
