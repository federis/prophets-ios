//
//  RemoteResource.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/19/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "NSManagedObject+Additions.h"

@interface Resource : NSManagedObject

@property (nonatomic, strong) NSNumber * remoteId;

+(RKEntityMapping *)responseMapping;
+(RKEntityMapping *)responseMappingWithChildRelationships;
+(RKEntityMapping *)responseMappingWithParentRelationships;

+(id)object;
+(id)findById:(NSNumber *)remoteId;

@end
