//
//  NSManagedObjectContext+ProphetsAdditions.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/28/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "NSManagedObjectContext+Additions.h"

@implementation NSManagedObjectContext (Additions)

NSString * const kModelName = @"prophets_ios";

static NSManagedObjectContext *_tempObjectContext = nil;

+(NSManagedObjectContext *)tempObjectContext{
    if (_tempObjectContext)
		return _tempObjectContext;
    
	// Create the context only on the main thread
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(tempObjectContext)
                               withObject:nil
                            waitUntilDone:YES];
		return _tempObjectContext;
	}
    
    
    // Create the object model for the temp context
    NSBundle *bundle = [NSBundle mainBundle];
	NSString *modelPath = [bundle pathForResource:kModelName ofType:@"momd"];
	NSManagedObjectModel *objectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:modelPath]];
    
    //Create the persistent store coordinator for the temp context
	NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *storePath = [documentsPath stringByAppendingPathComponent:@"temp_objects.sqlite"];
    
	NSFileManager *manager = [NSFileManager defaultManager];
	if ([manager fileExistsAtPath:storePath isDirectory:NO]) {
        NSError *error = nil;
        [manager removeItemAtPath:storePath error:&error];
        
		if (error) DLog(@"Error deleting temp object store: %@", [error localizedDescription]);
	}
	
	NSURL *storeURL = [NSURL fileURLWithPath:storePath];
    
	// Define the Core Data version migration options
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                             nil];
    
	// Attempt to load the persistent store
	NSError *error = nil;
	NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:objectModel];
	if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeURL
                                                         options:options
                                                           error:&error]) {
		DLog(@"Fatal error while creating persistent store: %@", error);
		abort();
	}
    
    
	_tempObjectContext = [[NSManagedObjectContext alloc] init];
	[_tempObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
    
	return _tempObjectContext;
}


- (NSSet *)fetchObjectsForEntityName:(NSString *)newEntityName withPredicate:(id)stringOrPredicate, ...
{
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:newEntityName inManagedObjectContext:self];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    if (stringOrPredicate)
    {
        NSPredicate *predicate;
        if ([stringOrPredicate isKindOfClass:[NSString class]])
        {
            va_list variadicArguments;
            va_start(variadicArguments, stringOrPredicate);
            predicate = [NSPredicate predicateWithFormat:stringOrPredicate
                                               arguments:variadicArguments];
            va_end(variadicArguments);
        }
        else
        {
            NSAssert2([stringOrPredicate isKindOfClass:[NSPredicate class]],
                      @"Second parameter passed to %s is of unexpected class %@",
                      sel_getName(_cmd), NSStringFromClass([stringOrPredicate class]));
            predicate = (NSPredicate *)stringOrPredicate;
        }
        [request setPredicate:predicate];
    }
    
    NSError *error = nil;
    NSArray *results = [self executeFetchRequest:request error:&error];
    if (error != nil)
    {
        [NSException raise:NSGenericException format:@"%@", [error description]];
    }
    
    return [NSSet setWithArray:results];
}



@end
