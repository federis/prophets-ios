//
//  FFBaseTableViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/10/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFBaseTableViewController.h"

@implementation FFBaseTableViewController

-(void)viewDidLoad{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardDidShow:(NSNotification *)note{
    if (!self.isViewLoaded || !self.view.window) return;
    
    CGRect keyboardFrame = [[[note userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [[[note userInfo] valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    if (CGRectEqualToRect(keyboardFrame, beginFrame)) return;
    
    //tableBottom = y + height
    //keyboardTop = view.height - keyboard.height
    CGFloat tableBottom = self.tableView.frame.origin.y + self.tableView.frame.size.height;
    CGFloat keyboardTop = self.view.frame.size.height - keyboardFrame.size.height;
    if(tableBottom != keyboardTop){
        self.tableView.frame = RectWithNewHeight(keyboardTop - self.tableView.frame.origin.y, self.tableView.frame);
    }
    
    UIView *firstResponder = [self currentFirstResponder];
    if (firstResponder != nil) {
        CGRect rectInTableViewCoordinates = [self.tableView convertRect:firstResponder.frame fromView:firstResponder];
        [self.tableView scrollRectToVisible:rectInTableViewCoordinates animated:YES];
    }
}

-(void)keyboardWillHide:(NSNotification *)note{
    if (!self.isViewLoaded || !self.view.window) return;
    
    CGRect keyboardFrame = [[[note userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [[[note userInfo] valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    if (CGRectEqualToRect(keyboardFrame, beginFrame)) return;
    
    self.tableView.frame = RectWithNewHeight(self.view.frame.size.height - 20, self.tableView.frame);
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
        [self loadData];
	}
}

-(void)setReloading:(BOOL)reloading{
    if (reloading) {
		[_pullToRefreshHeader setState:FFPullToRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
        [self setTopContentInset:_pullToRefreshHeader.height];
		[UIView commitAnimations];
    }
    else{
        [_pullToRefreshHeader setState:FFPullToRefreshNormal];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
        [self setTopContentInset:0];
		[UIView commitAnimations];
    }
    _reloading = reloading;
}

-(void)loadData{
    // called by pull to refresh header
    // can be overridden by subclasses to load data
    self.reloading = NO;
}

-(void)setTopContentInset:(float)value{
    self.tableView.contentInset = UIEdgeInsetsMake(value, self.tableView.contentInset.left, self.tableView.contentInset.bottom, self.tableView.contentInset.right);
}

-(void)setBottomContentInset:(float)value{
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top, self.tableView.contentInset.left, value, self.tableView.contentInset.right);
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
