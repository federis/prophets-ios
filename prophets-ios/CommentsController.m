//
//  CommentsController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/12/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "CommentsController.h"
#import "League.h"
#import "Question.h"

@implementation CommentsController

-(id)initWithQuestion:(Question *)question{
    self = [self init];
    if (self) {
        self.question = question;
        NSURL *url = [[RKObjectManager sharedManager].router URLForRelationship:@"comments" ofObject:self.question method:RKRequestMethodGET];
        [self setupWithUrl:url];
    }
    
    return self;
}

-(void)setupWithUrl:(NSURL *)url{
    self.fetchRequest = [RKArrayOfFetchRequestFromBlocksWithURL([RKObjectManager sharedManager].fetchRequestBlocks, url) lastObject];
    
    self.managedObjectContext = [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
}

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) return _fetchedResultsController;
    
    NSAssert(self.fetchRequest, @"Cannot initialize fetchedResultsController without a fetch request. Set fetchRequest property first.");
    NSAssert(self.fetchRequest, @"Cannot initialize fetchedResultsController without a context. Set managedObjectContext property first.");
    
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest
                                                                          managedObjectContext:self.managedObjectContext
                                                                            sectionNameKeyPath:self.sectionNameKeyPath
                                                                                     cacheName:self.cacheName];
    self.fetchedResultsController = frc;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

-(void)fetchComments{
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
}

-(NSInteger)numberofComments{
    return [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
}

-(Comment *)commentAtRow:(NSInteger)row{
    return [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
}

#pragma mark - Fetched Results Controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)object atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:1];
    newIndexPath = [NSIndexPath indexPathForRow:newIndexPath.row inSection:1];
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}




@end
