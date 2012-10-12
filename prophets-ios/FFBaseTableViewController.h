//
//  FFBaseTableViewController.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/10/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FFPullToRefreshHeader.h"

@interface FFBaseTableViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic) BOOL showsPullToRefresh;
@property (nonatomic, strong) FFPullToRefreshHeader *pullToRefreshHeader;

@end
