//
//  FFObjectManager.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/11/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFObjectManager.h"

@implementation FFObjectManager

-(void)setupRequestDescriptors{
/*    [self registerObjectMapping:[self userObjectMapping] withRootKeyPath:@"user"];
    [self setObjectMapping:[self membershipObjectMapping] forResourcePathPattern:@"/memberships" withFetchRequestBlock:^NSFetchRequest *(NSString *resourcePath) {
        NSFetchRequest *fetchRequest = [Membership fetchRequest];
        fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES]];
        return fetchRequest;
    }];*/
}

-(void)setupResponseDescriptors{
    
}

@end
