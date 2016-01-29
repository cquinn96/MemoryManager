//
//  RemindersViewController.h
//  MemoryManager
//
//  Created by Cormac Quinn on 18/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReminderDetailVC.h"

@interface RemindersViewController : UITableViewController <NSFetchedResultsControllerDelegate>

#import <CoreData/CoreData.h>

@property (strong, nonatomic) ReminderDetailVC *reminderDetailVC;

@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end