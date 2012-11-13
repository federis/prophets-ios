//
//  FFFetchedResultsViewController.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/24/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFBaseTableViewController.h"

@interface FFFetchedResultsViewController : FFBaseTableViewController<NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSFetchRequest *fetchRequest;
@property (nonatomic, copy) NSString *cacheName;
@property (nonatomic, copy) NSString *sectionNameKeyPath;
@property (nonatomic, strong) UIView *emptyContentFooterView;

@end
