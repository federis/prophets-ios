//
//  FormFieldCell.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/17/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFFormFieldCell.h"

@implementation FFFormFieldCell

-(id)formFieldCurrentValue{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"Invalid method call"
                                           "formFieldCurrentValue should only be invoked on subclasses of FFFormFieldCell"]
                                 userInfo:nil];
}

-(void)makeFirstResponder{
    //no-op by default
}

@end
