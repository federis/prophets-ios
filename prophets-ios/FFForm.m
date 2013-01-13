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
    form.fields = fields;
    
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

@end
