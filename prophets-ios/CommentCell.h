//
//  CommentCell.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/2/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFBaseCell.h"

@class Comment;

@interface CommentCell : FFBaseCell

@property (nonatomic, strong) Comment * comment;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentContentLabel;

-(CGFloat)heightForCellWithComment:(Comment *)comment;

@end
