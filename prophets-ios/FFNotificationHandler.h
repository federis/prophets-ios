//
//  FFNotificationHandler.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 3/13/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFNotificationHandler : NSObject

+(instancetype)sharedHandler;
-(void)handleNotification:(NSDictionary *)notificationInfo;

@end
