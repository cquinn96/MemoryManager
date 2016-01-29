//
//  EditRemindersTableVC.h
//  MemoryManager
//
//  Created by Cormac Quinn on 15/08/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "EditReminderVC.h"

@interface EditRemindersTableVC : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (nonatomic, retain) NSString *soundFilePath;
@property (nonatomic, retain) NSString *pictureFilePath;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) EditReminderVC *editReminderVC;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *guideArray;

@end