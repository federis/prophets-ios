//
//  RemoteResource.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/19/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <RestKit/RestKit.h>

#import "Resource.h"


@implementation Resource

@dynamic remoteId;

+(RKEntityMapping *)responseMapping{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"Invalid method call"
                                           "responseMapping is not implemented in this subclass"]
                                 userInfo:nil];
}

+(RKEntityMapping *)responseMappingWithChildRelationships{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"Invalid method call"
                                           "responseMappingWithChildeRelationships is not implemented in this subclass"]
                                 userInfo:nil];
}

+(RKEntityMapping *)responseMappingWithParentRelationships{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"Invalid method call"
                                           "responseMappingWithParentRelationships is not implemented in this subclass"]
                                 userInfo:nil];
}

+(id)object{
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                         inManagedObjectContext:[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext];
}

+(id)findById:(NSNumber *)remoteId{
    NSManagedObjectContext *context = [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
    return [context fetchObjectForEntityForName:NSStringFromClass(self) withValueForPrimaryKeyAttribute:remoteId];
}

@end
