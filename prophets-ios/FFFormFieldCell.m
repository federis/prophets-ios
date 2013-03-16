//
//  FormFieldCell.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/17/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFFormFieldCell.h"

@implementation FFFormFieldCell

-(void)makeFirstResponder{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"Invalid method call"
                                           "makeFirstResponder cannot be called on %@ cells", [self class]]
                                 userInfo:nil];
}

@end
