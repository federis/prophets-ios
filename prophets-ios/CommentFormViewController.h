//
//  CommentFormViewController.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/12/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFFormViewController.h"

@class League, Question, Membership, Comment;

@interface CommentFormViewController : FFFormViewController

@property (nonatomic, strong) Question *question;
@property (nonatomic, strong) League *league;
@property (nonatomic, strong) Comment *existingComment;

@end
