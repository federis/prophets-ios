//
//  FFPullToRefreshHeader.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/11/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFPullToRefreshHeader.h"
#import "FFLabel.h"
#import "UIColor+Additions.h"

@implementation FFPullToRefreshHeader

+(FFPullToRefreshHeader *)pullToRefreshHeaderForTableView:(UITableView *)tableView{
    return [[FFPullToRefreshHeader alloc] initWithTableView:tableView];
}

-(id)initWithTableView:(UITableView *)tableView{
    float height = 45.0f;
    CGRect frame = CGRectMake(0, -height, tableView.frame.size.width, height);
    
    self = [self initWithFrame:frame];
    if (self) {
        _height = height;
        
        self.backgroundColor = [UIColor clearColor];
        
        _textLabel = [[FFLabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 12.0f, self.frame.size.width, 12.0f)];
        _textLabel.fontSize = 11.0f;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_textLabel];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        /*
		_lastRefreshAtLabel = [[FFLabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
		_lastRefreshAtLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _lastRefreshAtLabel.fontSize = 10.0f;
		//_lastRefreshAtLabel.font = [UIFont systemFontOfSize:12.0f];
		//_lastRefreshAtLabel.textColor = [UIColor grayColor];
		//_lastRefreshAtLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		//_lastRefreshAtLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		_lastRefreshAtLabel.backgroundColor = [UIColor clearColor];
		_lastRefreshAtLabel.textAlignment = NSTextAlignmentCenter;
		[self addSubview:_lastRefreshAtLabel];
        */
        _arrow = [[CALayer alloc] init];
		_arrow.frame = CGRectMake(frame.size.width/2 - 15, frame.size.height - 35, 17.0f, 35.0f);
		_arrow.contentsGravity = kCAGravityResizeAspect;
		_arrow.contents = (id)[UIImage imageNamed:@"arrow-down.png"].CGImage;
		[[self layer] addSublayer:_arrow];
        
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _spinner.frame = CGRectMake(frame.size.width/2 - 10, 8.0f, 20.0f, 20.0f);
        _spinner.color = [UIColor creamColor];
        _spinner.hidesWhenStopped = YES;
        [self addSubview:_spinner];
    }

    return self;
}

-(void)setState:(FFPullToRefreshState)state{
	switch (state) {
		case FFPullToRefreshPulling:
			_textLabel.text = @"";
			[CATransaction begin];
			[CATransaction setAnimationDuration:.18];
			_arrow.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			break;
            
		case FFPullToRefreshNormal:
			if (_state == FFPullToRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:.18];
				_arrow.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			_textLabel.text = @"";
			[_spinner stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrow.hidden = NO;
			_arrow.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			break;
		case FFPullToRefreshLoading:
			
			_textLabel.text = @"Loading";
			[_spinner startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrow.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = state;
}

-(BOOL)isPulling{
    return _state == FFPullToRefreshPulling;
}

-(BOOL)isNormal{
    return _state == FFPullToRefreshNormal;
}

-(BOOL)isLoading{
    return _state == FFPullToRefreshLoading;
}

@end
