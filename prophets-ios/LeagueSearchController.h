//
//  LeagueSearchController.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 12/2/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeagueSearchController : UISearchDisplayController<UISearchDisplayDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSArray *searchResults;

@end
