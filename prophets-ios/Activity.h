//
//  Activity.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 4/22/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Resource.h"


@interface Activity : Resource

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * leagueId;
@property (nonatomic, retain) NSNumber * activityType;
@property (nonatomic, retain) NSNumber * feedableId;
@property (nonatomic, retain) NSString * feedableType;
@property (nonatomic, retain) NSNumber * commentsCount;

@end
