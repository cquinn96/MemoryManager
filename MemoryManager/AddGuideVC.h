//
//  AddGuideVC.h
//  MemoryManager
//
//  Created by Cormac Quinn on 26/07/2012.
//  Copyright (c) 2012 Cormac Quinn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Guide.h"
#import "Task.h"

@interface AddGuideVC : UITableViewController <UITableViewDelegate, UIPickerViewDelegate, UITextFieldDelegate> {
    UIActionSheet *dateSheet;
    NSDate *myDate;
    UIDatePicker *theDatePicker;
    BOOL reminderOn;
    Boolean reminderSet;
    BOOL snoozeOn;
}

@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSDate *myDate;
@property (nonatomic, retain) NSString *tempRepeat;
@property (nonatomic, retain) NSString *tempRepeatBeforeSelection;
@property (nonatomic, retain) NSString *tempSound;
@property (nonatomic, retain) NSString *tempSoundBeforeSelection;
@property (nonatomic, retain) Guide *detailItem;

- (IBAction)valueChanged:(id)sender;

-(void) dismissDateSet;

@end