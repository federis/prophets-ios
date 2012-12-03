//
//  Tag.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 12/1/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "Tag.h"
#import "Question.h"


@implementation Tag

@dynamic name;
@dynamic questions;


+(RKEntityMapping *)responseMapping{
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([self class])
                                                   inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    
    [mapping addAttributeMappingsFromArray:@[@"name"]];
    [mapping addAttributeMappingsFromDictionary:@{
     @"id" : @"remoteId"
     }];
    
    return mapping;
}

@end
