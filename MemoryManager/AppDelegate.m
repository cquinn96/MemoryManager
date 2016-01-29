//
//  AppDelegate.m
//  MemoryManager
//
//  Created by Cormac Quinn on 18/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "MasterViewController.h"
#import "RemindersViewController.h"
#import "SettingsViewController.h"
#import "Guide.h"   
#import "Task.h"
#import "Reminder.h"
#import "TaskViewController.h"
#import "ReminderDetailVC.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize navigationController = _navigationController;
@synthesize tabBarController = _tabBarController;
@synthesize notificationProperty;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    NSDictionary *defaultsDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:YES], @"FirstLaunch", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsDict];
    
    RemindersViewController *remindersViewController = [[RemindersViewController alloc] initWithNibName:@"RemindersViewController" bundle:nil];
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    MasterViewController *masterViewController = [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil];
    
    
    UINavigationController *navigationController2 = [[UINavigationController alloc] initWithRootViewController:remindersViewController];
    UINavigationController *navigationController3 = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    masterViewController.managedObjectContext = self.managedObjectContext;
    remindersViewController.managedObjectContext = self.managedObjectContext;
    
    //DetailViewController *detailViewController = [[DetailViewController alloc] initWithStyle:UITableViewStylePlain];
    //detailViewController.managedObjectContext = self.managedObjectContext;
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:self.navigationController, navigationController2, navigationController3, nil];
    [self.tabBarController setDelegate:self];
    
    //This sets any tab to the choosen one on start
    //self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:2];
            
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:102.0/255.0 green:41.0/255.0 blue:139.0/255.0 alpha:1]];
    
    notificationProperty = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];  
    if (notificationProperty) {       
        self.window.rootViewController = self.tabBarController;
        self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-grey.png"]];
        [self.window makeKeyAndVisible];
        [self showNotification:notificationProperty];
        return YES;
    }
    else {
        self.window.rootViewController = self.tabBarController;
        self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-grey.png"]];
        [self.window makeKeyAndVisible];
        return YES;
    }
    
//    self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-grey.png"]];
//    [self.window makeKeyAndVisible];
//    return YES;
}

//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
//    
//    if ([viewController isKindOfClass:[UINavigationController class]]) {
//        [(UINavigationController *)viewController popToRootViewControllerAnimated:NO];
//	}
//}

- (void)showNotification:(UILocalNotification *)localNotif{
    NSString *type = [localNotif.userInfo objectForKey:@"Type"];
    if ([type isEqualToString:@"Guide"]) {
        NSString *strID = [localNotif.userInfo objectForKey:@"ObjectID"];
        NSURL *urlID = [[NSURL alloc] initWithString:strID];
        NSManagedObjectID *objId = [[[self managedObjectContext] persistentStoreCoordinator] managedObjectIDForURIRepresentation:urlID];
        
        if([[self.managedObjectContext objectWithID:objId] isKindOfClass:[Guide class]]) {
            Guide *guide = (Guide *)[self.managedObjectContext objectWithID:objId];                
            
            
            TaskViewController *taskViewController = [TaskViewController new];
            taskViewController.detailItem = guide;
            
            [taskViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
            UINavigationController *GuideViewNav = [[UINavigationController alloc] initWithRootViewController:taskViewController];
            [self.window.rootViewController presentModalViewController:GuideViewNav animated:YES];
            
            //[self.window.rootViewController presentModalViewController:taskViewController animated:YES];
        }
    }
    else if([type isEqualToString:@"Reminder"]) {
        NSString *strID = [localNotif.userInfo objectForKey:@"ObjectID"];
        NSURL *urlID = [[NSURL alloc] initWithString:strID];
        NSManagedObjectID *objId = [[[self managedObjectContext] persistentStoreCoordinator] managedObjectIDForURIRepresentation:urlID];
        
        if([[self.managedObjectContext objectWithID:objId] isKindOfClass:[Reminder class]]) {
            Reminder *reminder = (Reminder *)[self.managedObjectContext objectWithID:objId];                
            
            ReminderDetailVC *reminderDetailVC = [ReminderDetailVC new];
            reminderDetailVC.detailItem = reminder;
            
            [reminderDetailVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
            UINavigationController *ReminderViewNav = [[UINavigationController alloc] initWithRootViewController:reminderDetailVC];
            [self.window.rootViewController presentModalViewController:ReminderViewNav animated:YES];
            
            //[self.window.rootViewController presentModalViewController:reminderDetailVC animated:YES];
        }
    }
    else {
        NSLog(@"Unrecognized remider %@", type);
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        [self showNotification:notificationProperty];
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if(application.applicationState == UIApplicationStateActive) { 
        notificationProperty = notification;
        UIAlertView *notifAlertView = [[UIAlertView alloc] initWithTitle:@"Alarm"
                                                                 message:notification.alertBody delegate:self
                                                       cancelButtonTitle:@"Cancel"
                                                       otherButtonTitles:@"Show", nil];
        [notifAlertView show];
        // alert, because app is running in foreground
    }
    else {
        [self showNotification:notification];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MemoryManager" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MemoryManager.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
