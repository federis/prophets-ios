//
//  FFDeepLinker.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 3/6/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFDeepLinker : NSObject

@property (nonatomic, strong) UIViewController *rootViewController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectContext *scratchContext;

-(void)handleUrl:(NSURL *)url;

@end
