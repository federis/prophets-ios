//
//  FFBaseViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/10/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFBaseViewController.h"

@interface FFBaseViewController ()

@end

@implementation FFBaseViewController

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImage *bgImage = [[UIImage imageNamed:@"background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(35, 0, 35, 0)];
    UIImageView *bgView = [[UIImageView alloc] initWithImage:bgImage];
    [self.view addSubview:bgView];
    [self.view sendSubviewToBack:bgView];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
