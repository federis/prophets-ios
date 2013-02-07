//
//  FFBaseTableViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/10/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFBaseTableViewController.h"

@interface FFBaseTableViewController ()

@property (nonatomic) BOOL reloading;

-(void)reloadData;

@end

@implementation FFBaseTableViewController

-(void)viewDidLoad{
    self.showsPullToRefresh = YES;
}

-(void)setFixedHeaderView:(UIView *)fixedHeaderView{
    if(self.fixedHeaderView) [self.fixedHeaderView removeFromSuperview];
    
    fixedHeaderView.frame = CGRectMake(7, 10, 303, fixedHeaderView.frame.size.height);
    _fixedHeaderView = fixedHeaderView;
    
    if (fixedHeaderView) {
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x,
                                          10 + fixedHeaderView.frame.size.height,
                                          self.tableView.frame.size.width,
                                          self.view.frame.size.height - 20 - fixedHeaderView.frame.size.height);
        [self.view addSubview:fixedHeaderView];
    }
    else{
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x,
                                          10,
                                          self.tableView.frame.size.width,
                                          self.view.frame.size.height - 20);
    }
}

-(void)setShowsPullToRefresh:(BOOL)showsPullToRefresh{
    if(showsPullToRefresh){
        [self addPullToRefreshHeader];
    }
    else{
        [self removePullToRefreshHeader];
    }
    
    _showsPullToRefresh = showsPullToRefresh;
}

-(void)addPullToRefreshHeader{
    self.pullToRefreshHeader = [FFPullToRefreshHeader pullToRefreshHeaderForTableView:self.tableView];
    
    [self.tableView addSubview:self.pullToRefreshHeader];
    self.tableView.showsVerticalScrollIndicator = YES;
}

-(void)removePullToRefreshHeader{
    [self.pullToRefreshHeader removeFromSuperview];
    self.pullToRefreshHeader = nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if (!self.showsPullToRefresh) return;
    
	if (scrollView.isDragging) {
		if (_pullToRefreshHeader.isPulling &&
            scrollView.contentOffset.y > -_pullToRefreshHeader.height &&
            scrollView.contentOffset.y < 0.0f &&
            !_reloading) {
            
			[_pullToRefreshHeader setState:FFPullToRefreshNormal];
            
		}
        else if (_pullToRefreshHeader.isNormal && scrollView.contentOffset.y < -_pullToRefreshHeader.height && !_reloading) {
			[_pullToRefreshHeader setState:FFPullToRefreshPulling];
		}
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (!self.showsPullToRefresh) return;
    
	if (scrollView.contentOffset.y <= -_pullToRefreshHeader.height && !_reloading) {
        self.reloading = YES;
        [self reloadData];
	}
}

-(void)setReloading:(BOOL)reloading{
    if (reloading) {
		[_pullToRefreshHeader setState:FFPullToRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		self.tableView.contentInset = UIEdgeInsetsMake(_pullToRefreshHeader.height, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
    }
    else{
        [_pullToRefreshHeader setState:FFPullToRefreshNormal];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
    }
    _reloading = reloading;
}

-(void)reloadData{
    // called by pull to refresh header
    // can be overridden by subclasses to load data
    self.reloading = NO;
}

@end
