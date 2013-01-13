//
//  FFForm.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 1/12/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FFFormField;

@protocol FFFormDelegate

-(void)formAddedField:(FFFormField *)field atRow:(NSUInteger)row;
-(void)formRemovedFieldAtRow:(NSInteger)row;

@end

@interface FFForm : NSObject

@property (nonatomic, strong) NSMutableArray *fields;
@property (nonatomic, strong) id object;
@property (nonatomic, weak) id<FFFormDelegate> delegate;

+(FFForm *)formForObject:(id)object withFields:(NSArray *)fields;

-(void)initializeFieldValuesFromObject;
-(void)serializeFormFieldValuesIntoObject;

-(void)insertFormField:(FFFormField *)field atRow:(NSUInteger)row;
-(void)removeFormFieldAtRow:(NSUInteger)row;

@end
