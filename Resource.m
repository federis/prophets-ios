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

+(RKEntityMapping *)requestMapping{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"Invalid method call"
                                           "requestMapping is not implemented in this subclass"]
                                 userInfo:nil];
}

@end
