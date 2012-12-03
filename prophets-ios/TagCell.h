//
//  TagCell.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 12/1/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Tag;

@interface TagCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) Tag *tag;

-(CGFloat)heightForCellWithTag:(Tag *)tag;

@end
