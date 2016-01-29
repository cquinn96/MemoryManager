//
//  AddReminderVC.h
//  MemoryManager
//
//  Created by Cormac Quinn on 02/08/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddReminderVC : UITableViewController <UITableViewDelegate, UIPickerViewDelegate, UITextFieldDelegate> {
    UIActionSheet *dateSheet;
    NSDate *myDate;
    UIDatePicker *theDatePicker;
}

@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSDate *myDate;
@property (nonatomic, retain) NSString *tempRepeat;
@property (nonatomic, retain) NSString *tempRepeatBeforeSelection;
@property (nonatomic, retain) NSString *tempSound;
@property (nonatomic, retain) NSString *tempSoundBeforeSelection;

- (IBAction)valueChanged:(id)sender;

-(void) dismissDateSet;

@end