//
//  FFFormAttribute.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/17/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    FFFormFieldTypeTextField = 1,
} FFFormFieldType;

@interface FFFormField : NSObject

@property (nonatomic, strong) NSString *attributeName;
@property (nonatomic) FFFormFieldType type;
@property (nonatomic, strong) NSString *labelName;
@property (nonatomic) BOOL secure;

+(FFFormField *)formFieldWithAttributeName:(NSString *)attributeName type:(FFFormFieldType)type labelName:(NSString *)labelName secure:(BOOL)secure;
+(FFFormField *)formFieldWithAttributeName:(NSString *)attributeName type:(FFFormFieldType)type secure:(BOOL)secure;

@end
