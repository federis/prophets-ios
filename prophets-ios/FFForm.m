//
//  FFForm.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 1/12/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import "FFForm.h"
#import "FFFormField.h"
#import "FFFormSection.h"

@implementation FFForm

-(id)initWithObject:(id)object sections:(NSArray *)sections{
    self = [self init];
    if (self) {
        self.object = object;
    
        self.sections = [sections mutableCopy];
        
        [self initializeFieldValuesFromObject];
        [self setInitialFirstResponder];
    }
    
    return self;
}

-(id)initWithObject:(id)object fields:(NSArray *)fields{
    FFFormSection *section = [[FFFormSection alloc] initWithFields:fields title:nil];
    return [self initWithObject:object sections:@[section]];
}

+(FFForm *)formForObject:(id)object withFields:(NSArray *)fields{
    return [[FFForm alloc] initWithObject:object fields:fields];
}

-(void)setInitialFirstResponder{
    BOOL hasInitialFirstResponder = NO;
    FFFormField *initalFirstResponderCandidate = nil;
    
    for (FFFormSection *section in self.sections){
        for (FFFormField *field in section.fields) {
            if(field.shouldBecomeFirstResponder){
                hasInitialFirstResponder = YES;
                break;
            }
            
            if (!initalFirstResponderCandidate && field.canBecomeFirstResponder) {
                initalFirstResponderCandidate = field;
            }
        }
    }
    
    if (!hasInitialFirstResponder && initalFirstResponderCandidate) {
        initalFirstResponderCandidate.shouldBecomeFirstResponder = YES;
    }

}

-(void)initializeFieldValuesFromObject{
    for (FFFormSection *section in self.sections) {
        for (FFFormField *field in section.fields) {
            field.currentValue = [self.object valueForKeyPath:field.attributeName];
        }
    }
}

-(void)serializeFormFieldValuesIntoObject{
    for (FFFormSection *section in self.sections) {
        for (FFFormField *field in section.fields) {
            [self.object setValue:field.currentValue forKey:field.attributeName];
        }
    }
}

-(void)insertFormField:(FFFormField *)field inSection:(NSUInteger)sectionIndex atRow:(NSUInteger)rowIndex{
    field.currentValue = [self.object valueForKeyPath:field.attributeName];
    FFFormSection *section = [self.sections objectAtIndex:sectionIndex];
    [section.fields insertObject:field atIndex:rowIndex];
    
    if (self.delegate) {
        [self.delegate formAddedField:field inSection:sectionIndex atRow:rowIndex];
    }
}

-(void)removeFormFieldFromSection:(NSUInteger)sectionIndex atRow:(NSUInteger)rowIndex{
    FFFormSection *section = [self.sections objectAtIndex:sectionIndex];
    [section.fields removeObjectAtIndex:rowIndex];
    
    if(self.delegate){
        [self.delegate formRemovedFieldFromSection:sectionIndex atRow:rowIndex];
    }
}

-(void)insertFormField:(FFFormField *)field atRow:(NSUInteger)rowIndex{
    [self insertFormField:field inSection:0 atRow:rowIndex];
}

-(void)removeFormFieldAtRow:(NSUInteger)rowIndex{
    [self removeFormFieldFromSection:0 atRow:rowIndex];
}

@end
