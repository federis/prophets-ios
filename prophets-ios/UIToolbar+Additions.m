//
//  UIToolbar+Additions.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 3/15/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import "UIToolbar+Additions.h"

@implementation UIToolbar (Additions)

+(UIToolbar *)toolbarWithDoneButtonForResponder:(UIResponder *)responder{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.tintColor = [UIColor blackColor];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleBordered target:responder action:@selector(resignFirstResponder)];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                            target:nil action:nil];
    [toolbar setItems:@[spacer, doneButton]];
    return toolbar;
}

@end
