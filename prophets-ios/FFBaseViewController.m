//
//  FFBaseViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/23/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <RestKit/RestKit.h>

#import "FFBaseViewController.h"

@interface FFBaseViewController ()

@end

@implementation FFBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(NSManagedObjectContext *)scratchContext{
    if(_scratchContext) return _scratchContext;
    
    _scratchContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    [_scratchContext performBlockAndWait:^{
        _scratchContext.parentContext = [RKObjectManager sharedManager].managedObjectStore.persistentStoreManagedObjectContext;
        _scratchContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;
    }];
    
    return _scratchContext;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.navigationItem) {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                       initWithImage:[UIImage imageNamed:@"back_arrow.png"]
                                       style:UIBarButtonItemStylePlain
                                       target:nil action:nil];
        
        self.navigationItem.backBarButtonItem = backButton;
    }
}

@end
