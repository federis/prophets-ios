//
//  FFBaseCell.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/10/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    FFCellTop = 1,
    FFCellMiddle,
    FFCellBottom,
    FFCellSingle,
} FFCellLocationInSection;

@interface FFBaseCell : UITableViewCell

-(FFCellLocationInSection)locationInSection;
-(void)setShadows;

@end
