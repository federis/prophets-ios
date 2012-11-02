//
//  Comment.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/2/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "Resource.h"

@class League, Question;

@interface Comment : Resource

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSNumber * leagueId;
@property (nonatomic, retain) NSNumber * questionId;
@property (nonatomic, retain) League *league;
@property (nonatomic, retain) Question *question;

@end
