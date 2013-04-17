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

-(void)formAddedField:(FFFormField *)field inSection:(NSUInteger)section atRow:(NSUInteger)row;
-(void)formRemovedFieldFromSection:(NSUInteger)section atRow:(NSInteger)row;

@end

@interface FFForm : NSObject

@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) id object;
@property (nonatomic, weak) id<FFFormDelegate> delegate;

-(id)initWithObject:(id)object sections:(NSArray *)sections;
-(id)initWithObject:(id)object fields:(NSArray *)fields;

+(FFForm *)formForObject:(id)object withFields:(NSArray *)fields;

-(void)initializeFieldValuesFromObject;
-(void)serializeFormFieldValuesIntoObject;

-(void)insertFormField:(FFFormField *)field inSection:(NSUInteger)sectionIndex atRow:(NSUInteger)rowIndex;
-(void)removeFormFieldFromSection:(NSUInteger)sectionIndex atRow:(NSUInteger)rowIndex;

-(void)insertFormField:(FFFormField *)field atRow:(NSUInteger)rowIndex;
-(void)removeFormFieldAtRow:(NSUInteger)rowIndex;

@end
