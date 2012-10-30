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
@property (nonatomic, strong) NSDate * createdAt;
@property (nonatomic, strong) NSDate * updatedAt;

+(RKEntityMapping *)responseMapping;
+(RKEntityMapping *)responseMappingWithChildRelationships;
+(RKEntityMapping *)responseMappingWithParentRelationships;
+(RKEntityMapping *)requestMapping;

+(id)object;
+(id)findById:(NSNumber *)remoteId;

@end
