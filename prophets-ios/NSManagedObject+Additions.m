//
//  NSManagedObject+Additions.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/28/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <RestKit/RestKit.h>

#import "NSManagedObject+Additions.h"
#import "NSManagedObjectContext+Additions.h"

@implementation NSManagedObject (Additions)

+(id)tempObject{
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                         inManagedObjectContext:[NSManagedObjectContext tempObjectContext]];
}

+(id)object{
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                  inManagedObjectContext:[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext];
}

+(NSArray *)findByAttribute:(NSString *)attribute withValue:(id)value{
    NSManagedObjectContext *context = [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class])
                                              inManagedObjectContext:context];
    [request setEntity:entity];
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"%@ == %@", attribute, value]];
    
    NSError *error;
    return [context executeFetchRequest:request error:&error];
}

@end
