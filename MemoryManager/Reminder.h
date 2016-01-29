//
//  Reminder.h
//  MemoryManager
//
//  Created by Cormac Quinn on 17/08/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Reminder : NSManagedObject

@property (nonatomic, retain) NSString * reminderAudio;
@property (nonatomic, retain) NSDate * reminderDate;
@property (nonatomic, retain) NSString * reminderName;
@property (nonatomic, retain) NSNumber * reminderSnooze;
@property (nonatomic, retain) NSString * reminderSound;
@property (nonatomic, retain) NSString * reminderRepeatInterval;
@property (nonatomic, retain) NSString * reminderPicture;

@end
