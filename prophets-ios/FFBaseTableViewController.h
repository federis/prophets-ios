//
//  FFBaseTableViewController.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/10/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FFBaseViewController.h"
#import "FFPullToRefreshHeader.h"
#import "Utilities.h"
#import "FFLabel.h"
#import "FFTableFooterButtonView.h"
#import "ClearButton.h"

@interface FFBaseTableViewController : FFBaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic) BOOL showsPullToRefresh;
@property (nonatomic, strong) FFPullToRefreshHeader *pullToRefreshHeader;
@property (nonatomic, strong) UIView *fixedHeaderView;
@property (nonatomic) BOOL reloading;

@property (nonatomic) CGRect fullTableViewFrame;

-(void)loadData;

@end
