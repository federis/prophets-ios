//
//  FFPullToRefreshHeader.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/11/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
    FFPullToRefreshPulling = 0,
    FFPullToRefreshNormal,
    FFPullToRefreshLoading,
    FFPullToRefreshUpToDate,
} FFPullToRefreshState;

@interface FFPullToRefreshHeader : UIView

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *lastRefreshAtLabel;
@property (nonatomic, strong) CALayer *arrow;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic) float height;
@property (nonatomic) FFPullToRefreshState state;

+(FFPullToRefreshHeader *)pullToRefreshHeaderForTableView:(UITableView *)tableView;
-(id)initWithTableView:(UITableView *)tableView;

-(BOOL)isPulling;
-(BOOL)isNormal;
-(BOOL)isLoading;

@end
