//
//  Task.h
//  MemoryManager
//
//  Created by Cormac Quinn on 14/08/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Guide;

@interface Task : NSManagedObject

@property (nonatomic, retain) NSDate * taskDate;
@property (nonatomic, retain) NSNumber * taskID;
@property (nonatomic, retain) NSString * taskName;
@property (nonatomic, retain) Guide *guide;

@end
