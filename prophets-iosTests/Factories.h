//
//  ObjectFactories.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/5/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User, League, Answer;

@interface Factories : NSObject

+(User *)userFactory;
+(League *)leagueFactory;
+(Answer *)answerFactory;

@end
