//
//  TableFooterButtonView.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/14/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFTableFooterButtonView : UIView

@property (nonatomic, strong) UIButton *button;

+(FFTableFooterButtonView *)footerButtonViewForTable:(UITableView *)tableView withText:(NSString *)text;

-(id)initWithFrame:(CGRect)frame text:(NSString *)text;

@end
