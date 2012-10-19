//
//  NSManagedObject+Additions.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/28/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "NSManagedObject+Additions.h"
#import "NSManagedObjectContext+Additions.h"

@implementation NSManagedObject (Additions)

+(id)tempObject{
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                         inManagedObjectContext:[NSManagedObjectContext tempObjectContext]];
}

@end
