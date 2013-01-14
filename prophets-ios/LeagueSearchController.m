//
//  LeagueSearchController.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 12/2/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <RestKit/RestKit.h>

#import "LeagueSearchController.h"
#import "LeagueCell.h"
#import "FFBaseTableViewController.h"

@implementation LeagueSearchController


-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.delegate = self;
    self.searchResultsDataSource = self;
    self.searchResultsDelegate = self;
    
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [[RKObjectManager sharedManager] getObjectsAtPathForRouteNamed:@"leagues" object:nil parameters:@{@"query":searchString}
       success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
           DLog(@"Result is %@", mappingResult);
           self.searchResults = [mappingResult array];
           [self.searchResultsTableView reloadData];
       }
       failure:^(RKObjectRequestOperation *operation, NSError *error){
           DLog(@"Error is %@", error);
       }];
    
    return NO;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView{
    [tableView registerNib:[UINib nibWithNibName:@"LeagueCell" bundle:[NSBundle mainBundle]]
    forCellReuseIdentifier:@"LeagueCell"];
    self.measuringCell = [tableView dequeueReusableCellWithIdentifier:@"LeagueCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchResults.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LeagueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeagueCell"];
    
    League *league = [self.searchResults objectAtIndex:indexPath.row];
    cell.league = league;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    League *league = (League *)[self.searchResults objectAtIndex:indexPath.row];
    return [self.measuringCell heightForCellWithLeague:league];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    League *league = (League *)[self.searchResults objectAtIndex:indexPath.row];
    [self.searchContentsController performSegueWithIdentifier:@"ShowJoinLeague" sender:league];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
