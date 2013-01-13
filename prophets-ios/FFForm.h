//
//  FFForm.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 1/12/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFForm : NSObject

@property (nonatomic, strong) NSArray *fields;
@property (nonatomic, strong) id object;

+(FFForm *)formForObject:(id)object withFields:(NSArray *)fields;
-(void)initializeFieldValuesFromObject;
-(void)serializeFormFieldValuesIntoObject;

@end
