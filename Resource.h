//
//  RemoteResource.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/19/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <RestKit/RestKit.h>

#import "NSManagedObject+Additions.h"
#import "NSDecimalNumber+Additions.h"
#import "NSNumber+Additions.h"
#import "NSManagedObject+Additions.h"

@interface Resource : NSManagedObject

@property (nonatomic, strong) NSNumber * remoteId;
@property (nonatomic, strong) NSDate * createdAt;
@property (nonatomic, strong) NSDate * updatedAt;

+(RKEntityMapping *)responseMapping;
+(RKEntityMapping *)requestMapping;

+(void)fetchOrLoadById:(NSNumber *)resourceId fromManagedObjectContext:(NSManagedObjectContext *)context beforeRemoteLoad:(void (^)(Resource *))beforeRemoteLoadBlock loaded:(void (^)(Resource *))loadedBlock failure:(void (^)(NSError *))failureBlock;

+(void)fetchAndLoadById:(NSNumber *)resourceId fromManagedObjectContext:(NSManagedObjectContext *)context beforeRemoteLoad:(void (^)(Resource *))beforeRemoteLoadBlock loaded:(void (^)(Resource *))loadedBlock loadedRemote:(void (^)(Resource *))loadedRemoteBlock failure:(void (^)(NSError *))failureBlock;

@end
