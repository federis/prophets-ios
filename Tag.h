//
//  Tag.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 12/7/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Resource.h"

@class League;

@interface Tag : Resource

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *leagues;
@end

@interface Tag (CoreDataGeneratedAccessors)

- (void)addLeaguesObject:(League *)value;
- (void)removeLeaguesObject:(League *)value;
- (void)addLeagues:(NSSet *)values;
- (void)removeLeagues:(NSSet *)values;

@end
