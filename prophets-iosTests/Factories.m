//
//  ObjectFactories.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/5/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>

#import "Factories.h"
#import "User.h"

@implementation Factories

+(User *)userFactory{
    User *user = [User createEntity];
    user.userId = [NSNumber numberWithInt:1];
    user.email = @"bcroesch@gmail.com";
    
    return user;
}


@end
