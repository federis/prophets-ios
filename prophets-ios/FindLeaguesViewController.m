//
//  FindLeaguesViewController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 12/1/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <RestKit/RestKit.h>

#import "FindLeaguesViewController.h"
#import "UIBarButtonItem+Additions.h"
#import "TagCell.h"

@interface FindLeaguesViewController ()

@end

@implementation FindLeaguesViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.leftItemsSupplementBackButton = YES;
    UIBarButtonItem * item = [UIBarButtonItem homeButtonItemWithTarget:self action:@selector(homeTouched)];
    
    self.navigationItem.leftBarButtonItems = @[item];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TagCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"TagCell"];
    
    self.measuringCell = [self.tableView dequeueReusableCellWithIdentifier:@"TagCell"];
    
    self.searchDisplayController.searchBar.backgroundImage = [UIImage imageNamed:@"transparent_pixel.png"];
    
    NSURL *url = [[RKObjectManager sharedManager].router URLForRouteNamed:@"tags" method:nil object:nil];
    self.fetchRequest = [RKArrayOfFetchRequestFromBlocksWithURL([RKObjectManager sharedManager].fetchRequestBlocks, url) lastObject];
    self.managedObjectContext = [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
    
    [[RKObjectManager sharedManager] getObjectsAtPathForRouteNamed:@"tags" object:nil parameters:nil
     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
         DLog(@"Result is %@", mappingResult);
     }
     failure:^(RKObjectRequestOperation *operation, NSError *error){
         DLog(@"Error is %@", error);
     }];
    
}

-(void)homeTouched{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Tag *tag = (Tag *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    return [self.measuringCell heightForCellWithTag:tag];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TagCell *cell = (TagCell *)[tableView dequeueReusableCellWithIdentifier:@"TagCell" forIndexPath:indexPath];
    
    Tag *tag = (Tag *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.tag = tag;
    
    return cell;
}


@end
