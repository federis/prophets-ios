//
//  FFFormSection.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 4/16/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import "FFFormSection.h"

@implementation FFFormSection

-(id)initWithFields:(NSArray *)fields title:(NSString *)title{
    self = [self init];
    if (self) {
        self.fields = [fields mutableCopy];
        self.title = title;
    }
    
    return self;
}

@end
