//
//  RemoteResource.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/19/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <RestKit/RestKit.h>

#import "Resource.h"
#import "NSManagedObjectContext+Additions.h"


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

+(RKEntityMapping *)requestMapping{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"Invalid method call"
                                           "requestMapping is not implemented in this subclass"]
                                 userInfo:nil];
}

+(void)fetchOrLoadById:(NSNumber *)resourceId fromManagedObjectContext:(NSManagedObjectContext *)context beforeRemoteLoad:(void (^)(Resource *))beforeRemoteLoadBlock loaded:(void (^)(Resource *))loadedBlock failure:(void (^)(NSError *))failureBlock{
    NSString *resourceName = NSStringFromClass([self class]);
    Resource *resource = [[context fetchObjectsForEntityName:resourceName
                                                withPredicate:@"remoteId = %i", [resourceId intValue]] anyObject];
    
    if(resource){
        loadedBlock(resource);
    }
    else{
        NSManagedObjectContext *scratchContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        
        [scratchContext performBlockAndWait:^{
            scratchContext.parentContext = context;
            scratchContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;
        }];
        
        resource = [scratchContext insertNewObjectForEntityForName:resourceName];
        resource.remoteId = resourceId;
        
        beforeRemoteLoadBlock(resource);
        [[RKObjectManager sharedManager] getObject:resource path:nil parameters:nil
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
               DLog(@"Result is %@", mappingResult);
               Resource *r = (Resource *)[context objectWithID:[resource objectID]];
               loadedBlock(r);
           }
           failure:^(RKObjectRequestOperation *operation, NSError *error){
               DLog(@"Error is %@", error);
               failureBlock(error);
           }];
    }
}

+(void)fetchAndLoadById:(NSNumber *)resourceId fromManagedObjectContext:(NSManagedObjectContext *)context beforeRemoteLoad:(void (^)(Resource *))beforeRemoteLoadBlock loaded:(void (^)(Resource *))loadedBlock loadedRemote:(void (^)(Resource *))loadedRemoteBlock failure:(void (^)(NSError *))failureBlock{
    NSString *resourceName = NSStringFromClass([self class]);
    Resource *resource = [[context fetchObjectsForEntityName:resourceName
                                               withPredicate:@"remoteId = %i", [resourceId intValue]] anyObject];
    
    NSManagedObjectContext *scratchContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    [scratchContext performBlockAndWait:^{
        scratchContext.parentContext = context;
        scratchContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;
    }];
    
    if(resource){
        loadedBlock(resource);
    }
    else{
        resource = [scratchContext insertNewObjectForEntityForName:resourceName];
        resource.remoteId = resourceId;
    }
    
    beforeRemoteLoadBlock(resource);
    DLog(@"Loading from remote");
    [[RKObjectManager sharedManager] getObject:resource path:nil parameters:nil
       success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
           DLog(@"\n\n GET SUCCEEDED \n\n");
           Resource *r = (Resource *)[context objectWithID:[resource objectID]];
           loadedRemoteBlock(r);
       }
       failure:^(RKObjectRequestOperation *operation, NSError *error){
           DLog(@"\n\n GET FAILED \n\n");
           failureBlock(error);
       }];
    
}

@end
