//
//  FFRouter.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/11/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFRouter.h"

#import "User.h"

@interface FFRouter()

-(void)setupRoutes;

@end


@implementation FFRouter

- (id)initWithBaseURL:(NSURL *)baseURL
{
    self = [super initWithBaseURL:baseURL];
    if (self) {
        [self setupRoutes];
    }
    
    return self;
}

- (id)init{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"%@ Failed to call designated initializer. Invoke initWithBaseURL: instead.", NSStringFromClass([self class])]
                                 userInfo:nil];
}

-(void)setupRoutes{
    //[self.routeSet addRoute:[RKRoute routeWithClass:[User class] pathPattern:@"/users/:remoteId" method:RKRequestMethodGET]];
    //[self.routeSet addRoute:[RKRoute routeWithClass:[User class] pathPattern:@"/users" method:RKRequestMethodPOST]];
    
    [self.routeSet addRoute:[RKRoute routeWithRelationshipName:@"memberships" objectClass:[User class] pathPattern:@"/memberships" method:RKRequestMethodGET]];
}

@end
