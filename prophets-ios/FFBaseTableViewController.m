//
//  FFBaseTableViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/10/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFBaseTableViewController.h"

@interface FFBaseTableViewController ()

@end

@implementation FFBaseTableViewController

- (void)viewDidLoad{
    [super viewDidLoad];

    //UIImage *bgImage = [[UIImage imageNamed:@"background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(100, 0, 100, 0)];
    UIImage *bgImage = [UIImage imageNamed:@"background.png"];
    UIImageView *bgView = [[UIImageView alloc] initWithImage:bgImage];
    self.tableView.backgroundView = bgView;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
