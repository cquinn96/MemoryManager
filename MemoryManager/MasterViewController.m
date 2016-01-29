//
//  MasterViewController.m
//  MemoryManager
//
//  Created by Cormac Quinn on 18/07/2012.
//  Copyright (c) 2012 Cormac Quinn. All rights reserved.
//

#import "MasterViewController.h"
#import "NSManagedObject+CRUD.h"
#import "Guide.h"
#import "Task.h"
#import "TaskViewController.h"
#import "AddGuideVC.h"

@interface MasterViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation MasterViewController

@synthesize guideArray;
@synthesize taskViewController = _taskViewController;
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Guides", @"Guides");
        self.tabBarItem.image = [UIImage imageNamed:@"guides"];
        self.view.backgroundColor = [UIColor clearColor];
        //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-grey.png"]];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    NSArray *notifArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    NSLog(@"There are %i notifications", [notifArray count]);
    
    NSUserDefaults *sharedDefaults = [NSUserDefaults standardUserDefaults];
    if ([sharedDefaults boolForKey:@"FirstLaunch"]) {
        
        Guide *g1 = [Guide createObject];
        g1.guideName = @"How to Use Guides";
        g1.guideCreationDate = [NSDate date];
        g1.guideRepeatInterval = @"Never";
        g1.guideSound =  @"Default";
        Task *t1 = [Task createObject];
        t1.taskName = @"You have selected a guide called 'How to Use Guides'. This is a task within a guide.";
        t1.taskDate = [NSDate date];
        Task *t2 = [Task createObject];
        t2.taskName = @"Above it tells you which task you are currently on and how many there are in the guide. This is task 2.";
        t2.taskDate = [NSDate date];
        Task *t3 = [Task createObject];
        t3.taskName = @"You can create your own guides and add your own tasks. Feel free to delete these starter guides in the 'Settings' tab.";
        t3.taskDate = [NSDate date];
        Task *t4 = [Task createObject];
        t4.taskName = @"To get the full benifits of this app, close it and go to Settings > Notifications > Memory Manager and change 'Banners' to 'Alerts' .";
        t4.taskDate = [NSDate date];
        g1.tasks = [NSSet setWithObjects:t1,t2,t3,t4, nil];
        
        Guide *g2 = [Guide createObject];
        g2.guideName = @"How to Use Reminders";
        g2.guideCreationDate = [NSDate date];
        g2.guideRepeatInterval = @"Never";
        g2.guideSound =  @"Default";
        Task *t5 = [Task createObject];
        t5.taskName = @"Create a new reminder in the 'Reminders' tab and give it a title.";
        t5.taskDate = [NSDate date];
        Task *t6 = [Task createObject];
        t6.taskName = @"You can then record sound (max 5 mins) and can add a picture to the reminder.";
        t6.taskDate = [NSDate date];
        Task *t7 = [Task createObject];
        t7.taskName = @"Finally set the date and time you want the reminder to alert the user at.";
        t7.taskDate = [NSDate date];
        Task *t8 = [Task createObject];
        t8.taskName = @"And thats it. Don't forget to rate this app on the store if it has helped in any way.";
        t8.taskDate = [NSDate date];
        g2.tasks = [NSSet setWithObjects:t5,t6,t7,t8, nil];
        
        Guide *g3 = [Guide createObject];
        g3.guideName = @"Sample Guide: Bedtime";
        g3.guideCreationDate = [NSDate date];
        g3.guideRepeatInterval = @"Never";
        g3.guideSound =  @"Default";
        Task *t9 = [Task createObject];
        t9.taskName = @"Lock the doors";
        t9.taskDate = [NSDate date];
        Task *t10 = [Task createObject];
        t10.taskName = @"Make sure the cooker is turned off";
        t10.taskDate = [NSDate date];
        Task *t11 = [Task createObject];
        t11.taskName = @"Put your iPhone on the charge. Good night";
        t11.taskDate = [NSDate date];
        g3.tasks = [NSSet setWithObjects:t9, t10, t11, nil];
               
        [Task saveDatabase];
        [Guide saveDatabase];
        //Do the stuff you want to do on first launch
        [sharedDefaults setBool:NO forKey:@"FirstLaunch"];
        [sharedDefaults synchronize];
    }
    
	// Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

//- (void)insertNewObject:(id)sender
//{
//    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
//    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
//    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
//    
//    // If appropriate, configure the new managed object.
//    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
//    [newManagedObject setValue:@"New Guide" forKey:@"guideName"];
//    
//    // Save the context.
//    NSError *error = nil;
//    if (![context save:&error]) {
//         // Replace this implementation with code to handle the error appropriately.
//         // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //return [[self.fetchedResultsController sections] count];
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0){
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    }
    else 
        return 1;
}

- (UIView *)tableView:(UITableView *)tv viewForFooterInSection:(NSInteger)section
{
    if (section == 0) 
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        if ([sectionInfo numberOfObjects]==0){
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 50)];
            label.text = @"There are no guides";
            
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:18];
            //label.shadowColor = [UIColor colorWithWhite:0.8 alpha:0.8];
            label.textColor = [UIColor whiteColor];
            
            label.lineBreakMode = UILineBreakModeWordWrap;
            label.textAlignment = UITextAlignmentCenter;
            label.numberOfLines = 0;
            
            [label sizeToFit];
            
            return label;
        }
        else {
            return nil;
        }
    }
    else
        return nil;
}

-(CGFloat)tableView:(UITableView *)tv heightForFooterInSection:(NSInteger)section
{
    if (section == 0) 
        return 40.0f;
    else 
        return 0.0f;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //cell.textLabel.textColor = [UIColor colorWithRed:56.0/255.0 green:84.0/255.0 blue:135.0/255.0 alpha:1];
        //cell.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    }
    if (indexPath.section==0) {
        [self configureCell:cell atIndexPath:indexPath];
    }
    else {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.text = @"Create New Guide";
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [cell setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1]];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
//    if(indexPath.section==0)
//        return YES;
//    else
        return NO;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
//        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
//        
//        NSError *error = nil;
//        if (![context save:&error]) {
//             // Replace this implementation with code to handle the error appropriately.
//             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        }
//    }   
//}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.taskViewController = [[TaskViewController alloc] initWithNibName:@"TaskViewController" bundle:nil];
    if(indexPath.section==0){
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        self.taskViewController.detailItem = object;
        [self.taskViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        UINavigationController *GuideViewNav = [[UINavigationController alloc] initWithRootViewController:self.taskViewController];
        [self presentModalViewController:GuideViewNav animated:YES];

    }
    else {
        AddGuideVC *addGuideView = [[AddGuideVC alloc] initWithStyle:UITableViewStyleGrouped];
        //UIViewController *vc = [[UIViewController alloc] init];
        UINavigationController *addGuideViewNav = [[UINavigationController alloc] initWithRootViewController:addGuideView];
        [self presentModalViewController:addGuideViewNav animated:YES];
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Guide" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"guideCreationDate" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [[object valueForKey:@"guideName"] description];
    NSString *temp = [NSString stringWithFormat:@"%i", [[object valueForKey:@"tasks"] count]];
    temp=[temp stringByAppendingString:@" tasks"];
    cell.detailTextLabel.text = temp;
}

@end
