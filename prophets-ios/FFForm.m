//
//  FFForm.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 1/12/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import "FFForm.h"
#import "FFFormField.h"

@implementation FFForm

+(FFForm *)formForObject:(id)object withFields:(NSArray *)fields{
    FFForm *form = [[FFForm alloc] init];
    form.object = object;
    form.fields = [fields mutableCopy];
    
    [form initializeFieldValuesFromObject];
    
    return form;
}

-(void)initializeFieldValuesFromObject{
    for (FFFormField *field in self.fields) {
        field.currentValue = [self.object valueForKeyPath:field.attributeName];
    }
}

-(void)serializeFormFieldValuesIntoObject{
    for (FFFormField *field in self.fields) {
        [self.object setValue:field.currentValue forKey:field.attributeName];
    }
}

-(void)insertFormField:(FFFormField *)field atRow:(NSUInteger)row{
    [self.fields insertObject:field atIndex:row];
    if (self.delegate) {
        [self.delegate formAddedField:field atRow:row];
    }
}

-(void)removeFormFieldAtRow:(NSUInteger)row{
    [self.fields removeObjectAtIndex:row];
    if(self.delegate){
        [self.delegate formRemovedFieldAtRow:row];
    }
}

@end
