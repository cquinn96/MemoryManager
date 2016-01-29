//
//  TaskViewController.h
//  MemoryManager
//
//  Created by Cormac Quinn on 26/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Guide.h"
#import "Task.h"

@interface TaskViewController : UIViewController{
    int count;
}

@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UITextView *taskNameLabel;
@property (nonatomic, retain) NSSet *taskList;
@property (nonatomic, retain) Guide *selectedGuide;
@property (nonatomic, retain) NSArray *listItems;
@property (nonatomic, retain) Guide *detailItem;
- (IBAction)doneButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *stepLabel;
@property (nonatomic, retain) NSString *myString;
@property (nonatomic, retain) NSString *aString;

@end
