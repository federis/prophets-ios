//
//  FFFetchedResultsViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/24/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFFetchedResultsViewController.h"

@interface FFFetchedResultsViewController ()

@end

@implementation FFFetchedResultsViewController

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) return _fetchedResultsController;
    
    if (!self.fetchRequest || !self.managedObjectContext) {
        DLog(@"Going to crash!");
    }
    
    NSAssert(self.fetchRequest, @"Cannot initialize fetchedResultsController without a fetch request. Set fetchRequest property first.");
    NSAssert(self.managedObjectContext, @"Cannot initialize fetchedResultsController without a context. Set managedObjectContext property first.");
    
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest
                                                                          managedObjectContext:self.managedObjectContext
                                                                            sectionNameKeyPath:self.sectionNameKeyPath
                                                                                     cacheName:self.cacheName];
    self.fetchedResultsController = frc;
    self.fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _fetchedResultsController.delegate = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
    
    [self updateEmptyContentFooterView];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}
/*
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)object atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            ; //prevents compile error
            [tableView reloadData];
            //NSInteger start = indexPath.section < newIndexPath.section ? indexPath.section : newIndexPath.section;
            //NSInteger len = fabs(indexPath.section - newIndexPath.section);
            //NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(start, len+1)];
            //[tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
            //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            //[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

*/

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    //[self.tableView endUpdates];
    [self.tableView reloadData];
    
    [self updateEmptyContentFooterView];
}

-(void)setEmptyContentFooterView:(UIView *)emptyContentFooterView{
    _emptyContentFooterView = emptyContentFooterView;
    
    [self updateEmptyContentFooterView];
}

-(void)updateEmptyContentFooterView{
    if(self.emptyContentFooterView){
        if (self.fetchedResultsController.fetchedObjects.count == 0) {
            self.tableView.tableFooterView = self.emptyContentFooterView;
        }
        else if([self.tableView.tableFooterView isEqual:self.emptyContentFooterView]){
            self.tableView.tableFooterView = nil;
        }
    }
}

-(void)dealloc{
    _fetchedResultsController.delegate = nil;
}


@end
