//
//  FFDeepLinker.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 3/6/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import <Foundation/Foundation.h>

@class League, Question, Membership;

@interface FFDeepLinker : NSObject

@property (nonatomic, strong) UIWindow *appWindow;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectContext *scratchContext;

+(instancetype)sharedLinker;
+(void)setSharedLinker:(FFDeepLinker *)linker;
-(void)handleUrl:(NSURL *)url;

-(void)showLeague:(League *)league;
-(void)showJoinLeague:(League *)league;
-(void)showQuestion:(Question *)question withMembership:(Membership *)membership;

@end
