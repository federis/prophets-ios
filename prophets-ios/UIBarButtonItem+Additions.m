//
//  UIBarButtonItem+Additions.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/23/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "UIBarButtonItem+Additions.h"

@implementation UIBarButtonItem (Additions)

+(UIBarButtonItem *)homeButtonItemWithTarget:(id)target action:(SEL)action{
    return [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home.png"] style:UIBarButtonItemStylePlain target:target action:action];
}

@end
