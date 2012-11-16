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
@dynamic createdAt;
@dynamic updatedAt;

+(RKEntityMapping *)responseMapping{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"Invalid method call"
                                           "responseMapping is not implemented in this subclass"]
                                 userInfo:nil];
}

+(RKEntityMapping *)responseMappingWithChildRelationships{
    return [self responseMapping];
}

+(RKEntityMapping *)responseMappingWithParentRelationships{
    return [self responseMapping];
}

+(RKEntityMapping *)requestMapping{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"Invalid method call"
                                           "requestMapping is not implemented in this subclass"]
                                 userInfo:nil];
}

-(void)deleteFromManagedObjectContext{
    [self.managedObjectContext deleteObject:self];
}

+(id)object{
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self)
                                         inManagedObjectContext:[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext];
}

+(id)findById:(NSNumber *)remoteId{
    NSManagedObjectContext *context = [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
    return [context fetchObjectForEntityForName:NSStringFromClass(self) withValueForPrimaryKeyAttribute:remoteId];
}

@end
