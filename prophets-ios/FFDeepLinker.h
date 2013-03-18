//
//  FFDeepLinker.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 3/6/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFDeepLinker : NSObject

@property (nonatomic, strong) UIWindow *appWindow;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectContext *scratchContext;

+(instancetype)sharedLinker;
+(void)setSharedLinker:(FFDeepLinker *)linker;
-(void)handleUrl:(NSURL *)url;

@end
