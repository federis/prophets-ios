//
//  FFFormAttribute.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/17/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFFormField.h"
#import "NSString+Additions.h"

@implementation FFFormField

+(FFFormField *)formFieldWithAttributeName:(NSString *)attributeName type:(FFFormFieldType)type labelName:(NSString *)labelName secure:(BOOL)secure{
    FFFormField *field = [[FFFormField alloc] init];
    field.attributeName = attributeName;
    field.type = type;
    field.labelName = labelName;
    field.secure = secure;
    
    return field;
}

+(FFFormField *)formFieldWithAttributeName:(NSString *)attributeName type:(FFFormFieldType)type secure:(BOOL)secure{
    return [self formFieldWithAttributeName:attributeName type:type labelName:[attributeName humanized] secure:secure];
}

@end
