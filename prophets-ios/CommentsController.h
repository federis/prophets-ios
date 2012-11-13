//
//  CommentsController.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/12/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <Foundation/Foundation.h>

@class League, Question, Comment;

@interface CommentsController : NSObject<NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSFetchRequest *fetchRequest;
@property (nonatomic, copy) NSString *cacheName;
@property (nonatomic, copy) NSString *sectionNameKeyPath;

@property (nonatomic, strong) League *league;
@property (nonatomic, strong) Question *question;

@property (nonatomic, weak) UITableView *tableView;

-(id)initWithQuestion:(Question *)question;
-(void)fetchComments;
-(NSInteger)numberofComments;
-(Comment *)commentAtRow:(NSInteger)row;

@end
