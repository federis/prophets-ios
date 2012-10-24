//
//  FFObjectManager.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/11/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFObjectManager.h"
#import "User.h"
#import "Membership.h"

@implementation FFObjectManager

-(void)setupRequestDescriptors{
    [self addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:[User requestMapping]
                                                                     objectClass:[User class]
                                                                     rootKeyPath:@"user"]];
}

-(void)setupResponseDescriptors{
    [self addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[User responseMapping]
                                                                        pathPattern:nil
                                                                            keyPath:@"user"
                                                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [self addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[Membership responseMapping]
                                                                        pathPattern:nil
                                                                            keyPath:@"membership"
                                                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
}

-(void)setupFetchRequestBlocks{
    [self addFetchRequestBlock:^NSFetchRequest *(NSURL *url){
        RKPathMatcher *pathMatcher = [RKPathMatcher pathMatcherWithPattern:@"/memberships"];
        BOOL match = [pathMatcher matchesPath:[url relativePath] tokenizeQueryStrings:NO parsedArguments:nil];
        
        if (match) {
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Membership"];
            fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:YES]];
            return fetchRequest;
        }
        
        return nil;
    }];
}

@end
