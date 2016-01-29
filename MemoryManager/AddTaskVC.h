//
//  AddTaskVC.h
//  MemoryManager
//
//  Created by Cormac Quinn on 31/07/2012.
//  Copyright (c) 2012 Cormac Quinn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AddTaskVC : UITableViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *taskArray;
@property (nonatomic, retain) NSString *tempTask;
@property (nonatomic, retain) NSMutableArray *textFieldArray;
@property (nonatomic, retain) NSMutableArray *tasks;

@end