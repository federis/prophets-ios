//
//  ErrorCollection.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 1/13/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ErrorCollection : NSObject

@property (nonatomic, strong) NSArray *messages;

-(NSString *)messagesString;

@end
