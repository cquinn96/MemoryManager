//
//  EditTasksVC.h
//  MemoryManager
//
//  Created by Cormac Quinn on 15/08/2012.
//  Copyright (c) 2012 Cormac Quinn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Guide.h"
#import <CoreData/CoreData.h>

@interface EditTasksVC : UITableViewController <UITextFieldDelegate>{
    int count;
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *taskArray;
@property (nonatomic, retain) NSString *tempTask;
@property (nonatomic, retain) Guide *detailItem;
@property (nonatomic, retain) NSSet *taskSet;
@property (nonatomic, retain) NSArray *tasksToBeShownArray;

@end