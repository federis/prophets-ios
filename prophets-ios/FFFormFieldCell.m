//
//  FormFieldCell.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/17/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFFormFieldCell.h"

@implementation FFFormFieldCell

+(NSString *)cellReuseIdentifierForFormField:(FFFormField *)field{
    if(field.type == FFFormFieldTypeTextField){
        return @"FFTextFieldCell";
    }
    
    return @"FFTextFieldCell";
}

-(id)formFieldCurrentValue{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"Invalid method call"
                                           "formFieldCurrentValue should only be invoke on subclasses of FFFormFieldCell"]
                                 userInfo:nil];
}

@end
