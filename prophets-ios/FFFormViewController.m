//
//  FFFormViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/11/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFFormViewController.h"
#import "TextFieldCell.h"

@interface FFFormViewController ()

@end

@implementation FFFormViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TextFieldCell class])
                                               bundle:nil] forCellReuseIdentifier:@"TextFieldCell"];
}

@end
