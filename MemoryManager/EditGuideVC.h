//
//  EditGuideVC.h
//  MemoryManager
//
//  Created by Cormac Quinn on 14/08/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Guide.h"
#import "Task.h"
#import <CoreData/CoreData.h>

@interface EditGuideVC : UITableViewController <UITableViewDelegate, UIPickerViewDelegate, UITextFieldDelegate, NSFetchedResultsControllerDelegate> {
    UIActionSheet *dateSheet;
    NSDate *myDate;
    UIDatePicker *theDatePicker;
    BOOL reminderOn;
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSDate *myDate;
@property (nonatomic, retain) NSString *tempRepeat;
@property (nonatomic, retain) Guide *detailItem;
@property (nonatomic, retain) NSSet *taskSet;
@property (nonatomic, retain) NSArray *taskArray;
@property (nonatomic, retain) NSString *tempRepeatBeforeSelection;
@property (nonatomic, retain) NSString *tempSound;
@property (nonatomic, retain) NSString *tempSoundBeforeSelection;

- (IBAction)valueChanged:(id)sender;

-(void) dismissDateSet;

@end