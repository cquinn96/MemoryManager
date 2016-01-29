//
//  SettingsViewController.m
//  MemoryManager
//
//  Created by Cormac Quinn on 18/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "EditGuidesTableVC.h"
#import "EditRemindersTableVC.h"
#import "AboutVC.h"
#import "AppDelegate.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Settings", @"Settings");
        self.tabBarItem.image = [UIImage imageNamed:@"settings"];
        self.view.backgroundColor = [UIColor clearColor];
        //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0){
        return 2;
    }
    else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    //if the cell is nil (not allocated memory), allocate it memory and initialise with the default style and the CellIdentifier
    
    if(indexPath.section==0){
        if(indexPath.row == 0){
            cell.textLabel.text = @"Edit Guides";
        }
        else {
            cell.textLabel.text = @"Edit Reminders";
        }
    }
    if(indexPath.section==1){
        if(indexPath.row == 0){
            cell.textLabel.text = @"About";
        }
    }
    
    [cell setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1]];
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            EditGuidesTableVC *editGuidesVC = [[EditGuidesTableVC alloc] initWithNibName:@"EditGuidesTableVC" bundle:nil];
            [self.navigationController pushViewController:editGuidesVC animated:YES];
        }
        if (indexPath.row==1) {
            EditRemindersTableVC *editRemindersVC = [[EditRemindersTableVC alloc] initWithNibName:@"EditRemindersTableVC" bundle:nil];
            [self.navigationController pushViewController:editRemindersVC animated:YES];
        }
    }
    else if (indexPath.section==1) {
        if (indexPath.row==0) {
                AboutVC *aboutVC = [[AboutVC alloc] initWithNibName:@"AboutVC" bundle:nil];
                [self.navigationController pushViewController:aboutVC animated:YES];
        }
    }
}

@end