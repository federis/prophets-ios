//
//  UIAlertView+Additions.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 1/31/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Additions)<UIAlertViewDelegate>

- (id)initWithTitle:(NSString *)title message:(NSString *)message completionBlock:(void (^)(NSUInteger buttonIndex, UIAlertView *alertView))block cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

@end
