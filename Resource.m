//
//  RemoteResource.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/19/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <RestKit/RestKit.h>

#import "Resource.h"


@implementation Resource

-(BOOL)validateValue:(id *)value forKey:(NSString *)key error:(NSError **)error{
    NSString *idName = [NSString stringWithFormat:@"%@Id", [NSStringFromClass([self class]) lowercaseString]];
    if([key isEqualToString:idName]){
        
    }
    
    return YES;
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
