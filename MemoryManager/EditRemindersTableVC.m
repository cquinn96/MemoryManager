//
//  EditRemindersTableVC.m
//  MemoryManager
//
//  Created by Cormac Quinn on 15/08/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EditRemindersTableVC.h"
#import "Reminder.h"
#import "NSManagedObject+CRUD.h"

@interface EditRemindersTableVC ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation EditRemindersTableVC

@synthesize dateFormatter;
@synthesize detailItem;
@synthesize detailDescriptionLabel, soundFilePath, pictureFilePath;
@synthesize guideArray;
@synthesize editReminderVC = _editReminderVC;
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;

- (NSManagedObjectContext *)managedObjectContext {
    if(!__managedObjectContext) {
        id appDelegate = (id)[[UIApplication sharedApplication] delegate];
        __managedObjectContext = [appDelegate managedObjectContext];
    }
    
    return __managedObjectContext;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Edit Reminders", @"Edit Reminders");
        self.tabBarItem.image = [UIImage imageNamed:@"179-notepad"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
	[self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[self.fetchedResultsController sections] count];
    //return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UIView *)tableView:(UITableView *)tv viewForFooterInSection:(NSInteger)section
{
    if (section == 0) 
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        if ([sectionInfo numberOfObjects]==0){
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 50)];
            label.text = @"There are no reminders";
            //@"SOME TEXT FOR SECTION 1\r\n"
            
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section==0)
        [self configureCell:cell atIndexPath:indexPath];
    
    [cell setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1]];
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        soundFilePath = [[object valueForKey:@"reminderAudio"] description];
        pictureFilePath = [[object valueForKey:@"reminderPicture"] description];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error = nil;
        BOOL soundFileExists = [fileManager fileExistsAtPath:soundFilePath];
        BOOL pictureFileExists = [fileManager fileExistsAtPath:pictureFilePath];

        if (soundFileExists) {
            BOOL success = [fileManager removeItemAtPath:soundFilePath error:&error];
            if (!success) NSLog(@"Error: %@", [error localizedDescription]);
        }
        if (pictureFileExists) {
            BOOL success = [fileManager removeItemAtPath:pictureFilePath error:&error];
            if (!success) NSLog(@"Error: %@", [error localizedDescription]);
        }
        
        NSManagedObjectID *objID = [object objectID];
        NSURL *urlID = [objID URIRepresentation];
        NSString *strIDToDelete = [urlID absoluteString];
        
        UIApplication *app = [UIApplication sharedApplication];
        NSArray *notifArray = [app scheduledLocalNotifications];
        NSLog(@"There are %i notifications before deletion", [notifArray count]);
        for (int i=0; i<[notifArray count]; i++)
        {
            UILocalNotification* notification = [notifArray objectAtIndex:i];
            NSString *strID = [notification.userInfo objectForKey:@"ObjectID"];
            if ([strID isEqualToString:strIDToDelete])
            {
                //Cancelling local notification
                [app cancelLocalNotification:notification];
                break;
            }
        }
        
        NSArray *notifArrayNow = [app scheduledLocalNotifications];
        NSLog(@"There are %i notifications after deletion", [notifArrayNow count]);
        
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }      
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        EditReminderVC *editReminderView = [[EditReminderVC alloc] initWithStyle:UITableViewStyleGrouped];
        UINavigationController *editReminderViewNav = [[UINavigationController alloc] initWithRootViewController:editReminderView];
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        editReminderView.detailItem = object;
        [self presentModalViewController:editReminderViewNav animated:YES];
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
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Reminder" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"reminderName" ascending:NO];
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
    cell.textLabel.text = [[object valueForKey:@"reminderName"] description];
    //NSString *tempDetail = [self.dateFormatter stringFromDate:[object valueForKey:@"reminderDate"]];
    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:[object valueForKey:@"reminderDate"]];
}

@end
