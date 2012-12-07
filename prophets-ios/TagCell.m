//
//  TagCell.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 12/1/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "TagCell.h"
#import "Tag.h"
#import "Utilities.h"


@implementation TagCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.showsAccessoryView = YES;
}

-(void)setTag:(Tag *)tag{
    self.nameLabel.text = tag.name;
}

-(CGFloat)heightForCellWithTag:(Tag *)tag{
    return 23 + [Utilities heightForString:tag.name
                                  withFont:self.nameLabel.font
                                     width:self.nameLabel.frame.size.width];
}


@end
