//
//  EditGuidesTableVC.h
//  MemoryManager
//
//  Created by Cormac Quinn on 19/07/2012.
//  Copyright (c) 2012 Cormac Quinn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AddGuideVC.h"
#import "EditGuideVC.h"

@interface EditGuidesTableVC : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (strong, nonatomic) EditGuideVC *editGuideVC;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *guideArray;

@end