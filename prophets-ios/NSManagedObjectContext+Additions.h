//
//  NSManagedObjectContext+ProphetsAdditions.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/28/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (Additions)

+(NSManagedObjectContext *)tempObjectContext;

@end
