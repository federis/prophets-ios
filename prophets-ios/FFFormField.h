//
//  FFFormAttribute.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/17/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFFormField : NSObject

@property (nonatomic, strong) NSString *attributeName;
@property (nonatomic, strong) NSString *labelName;

+(id)formFieldWithAttributeName:(NSString *)attributeName labelName:(NSString *)labelName;
+(id)formFieldWithAttributeName:(NSString *)attributeName;

-(id)initWithAttributeName:(NSString *)attributeName labelName:(NSString *)labelName;

-(NSString *)cellReuseIdentifier;

@end
