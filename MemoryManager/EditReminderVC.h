//
//  EditReminderVC.h
//  MemoryManager
//
//  Created by Cormac Quinn on 16/08/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reminder.h"

@interface EditReminderVC : UITableViewController <UITableViewDelegate, UIPickerViewDelegate, UITextFieldDelegate, NSFetchedResultsControllerDelegate> {
    UIActionSheet *dateSheet;
    NSDate *myDate;
    UIDatePicker *theDatePicker;
}

@property (nonatomic, retain) Reminder *detailItem;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSDate *myDate;
@property (nonatomic, retain) NSString *tempRepeat;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSString *tempRepeatBeforeSelection;
@property (nonatomic, retain) NSString *tempSoundBeforeSelection;
@property (nonatomic, retain) NSString *tempSound;
@property (nonatomic, retain) NSString *soundFilePath;
@property (nonatomic, retain) NSString *pictureFilePath;

- (IBAction)valueChanged:(id)sender;

-(void) dismissDateSet;

@end