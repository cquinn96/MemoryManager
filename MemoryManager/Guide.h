//
//  Guide.h
//  MemoryManager
//
//  Created by Cormac Quinn on 06/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Task;

@interface Guide : NSManagedObject

@property (nonatomic, retain) NSDate * guideDate;
@property (nonatomic, retain) NSString * guideName;
@property (nonatomic, retain) NSNumber * guideReminderOn;
@property (nonatomic, retain) NSString * guideRepeatInterval;
@property (nonatomic, retain) NSNumber * guideSnooze;
@property (nonatomic, retain) NSString * guideSound;
@property (nonatomic, retain) NSDate * guideCreationDate;
@property (nonatomic, retain) NSSet *tasks;
@end

@interface Guide (CoreDataGeneratedAccessors)

- (void)addTasksObject:(Task *)value;
- (void)removeTasksObject:(Task *)value;
- (void)addTasks:(NSSet *)values;
- (void)removeTasks:(NSSet *)values;

@end
