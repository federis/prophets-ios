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

+(id)formFieldWithAttributeName:(NSString *)attributeName labelName:(NSString *)labelName{
    return [[self alloc] initWithAttributeName:attributeName labelName:labelName];
}

+(id)formFieldWithAttributeName:(NSString *)attributeName{
    return [self formFieldWithAttributeName:attributeName labelName:[attributeName humanized]];
}

-(id)initWithAttributeName:(NSString *)attributeName labelName:(NSString *)labelName{
    self = [super init];
    if(self){
        self.attributeName = attributeName;
        self.labelName = labelName;
    }
    
    return self;
}

-(NSString *)cellReuseIdentifier{
    if (self.customCellReuseIdentifier) {
        return self.customCellReuseIdentifier;
    }
    
    return [NSString stringWithFormat:@"%@Cell", NSStringFromClass([self class])];
}

-(CGFloat)height{
    return 44;
}

-(BOOL)canBecomeFirstResponder{
    return NO;
    /*
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"Invalid method call"
                                           "canBecomeFirstResponder must be implemented by subclasses of FFFormField"]
                                 userInfo:nil];
     */
}

@end
