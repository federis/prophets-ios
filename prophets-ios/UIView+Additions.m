//
//  UITextField+Additions.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 3/15/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView (Additions)

-(UITableViewCell *)findParentTableViewCell{
    UIView *view = [self superview];
    while(view){
        if ([view isKindOfClass:[UITableViewCell class]]) return (UITableViewCell *)view;
        view = [view superview];
    }
    
    return nil;
}

@end
