//
//  MasterViewController.h
//  MemoryManager
//
//  Created by Cormac Quinn on 18/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;
@class GuideTableVC;
@class TaskViewController;

#import <CoreData/CoreData.h>

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

//@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) TaskViewController *taskViewController;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) NSMutableArray *guideArray;

@end