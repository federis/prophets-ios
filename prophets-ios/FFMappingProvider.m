//
//  FFMappingProvider.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/19/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFMappingProvider.h"

@implementation FFMappingProvider

@synthesize  objectStore;

+ (id)mappingProviderWithObjectStore:(RKManagedObjectStore *)objectStore {
    return [[self alloc] initWithObjectStore:objectStore];
}

- (id)initWithObjectStore:(RKManagedObjectStore *)os {
    self = [super init];
    if (self) {
        self.objectStore = os;
    }
    
    return self;
}

@end
