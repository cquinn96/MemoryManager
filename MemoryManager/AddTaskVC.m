//
//  AddTaskVC.m
//  MemoryManager
//
//  Created by Cormac Quinn on 31/07/2012.
//  Copyright (c) 2012 Cormac Quinn. All rights reserved.
//

#import "AddTaskVC.h"
#import "NSManagedObject+CRUD.h"
#import "Task.h"
#import "MasterViewController.h"

@interface AddTaskVC () {
    BOOL isInTheMiddleOfEditing;
}

@end

@implementation AddTaskVC

@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize taskArray, textFieldArray, tempTask, tasks;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        isInTheMiddleOfEditing = NO;
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Add Tasks", @"Add Tasks");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tasks = [NSMutableArray new];
    taskArray = [NSMutableArray new];
    [taskArray addObject:@""];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewTask:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
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

- (void)addNewTask:(id)sender
{
        NSString *previousTextField = [taskArray objectAtIndex:([taskArray count] - 1)];
        if (![previousTextField isEqualToString:@""]) {
            [taskArray addObject:@""];
            [self.tableView reloadData];
        }
        NSLog(@"replacing Object %@ at index %i with '%@'",previousTextField,([taskArray count] - 1),previousTextField);
        [taskArray replaceObjectAtIndex:([taskArray count] - 1) withObject:previousTextField];
        [self.tableView reloadData];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //[textField resignFirstResponder];
    
    NSString *currentTextField = textField.text;
    NSLog(@"replacing Object %@ at index %i with '%@'",[taskArray objectAtIndex:textField.tag],textField.tag,textField.text);
    //textField.text.length > 1
    [taskArray replaceObjectAtIndex:textField.tag withObject:textField.text];
    [self.tableView reloadData];
    
    if (![currentTextField isEqualToString:@""]) {
        if(![[taskArray objectAtIndex:([taskArray count] -1)] isEqualToString:@""]) {
            [taskArray addObject:@""];
            [self.tableView reloadData];
        }
    }
    
    isInTheMiddleOfEditing = NO;
    
    return YES;
    //[self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
}


-(void)addNewBlankTask:(UITextField *)textField {
    NSString *currentTextField = textField.text;
    if (![currentTextField isEqualToString:@""]) {
        [taskArray addObject:@""];
        [self.tableView reloadData];
    }
    
    NSLog(@"replacing Object %@ at index %i with '%@'",[taskArray objectAtIndex:textField.tag],textField.tag,textField.text);
    [taskArray replaceObjectAtIndex:textField.tag withObject:textField.text];
    [self.tableView reloadData];
}

- (void)textFieldEditingDidEnd:(UITextField *)textField {
    
    NSString *currentTextField = textField.text;
    if (![currentTextField isEqualToString:@""]) {
        [taskArray addObject:@""];
        [self.tableView reloadData];
    }
    
    NSLog(@"replacing Object %@ at index %i with '%@'",[taskArray objectAtIndex:textField.tag],textField.tag,textField.text);
    [taskArray replaceObjectAtIndex:textField.tag withObject:textField.text];
    [self.tableView reloadData];
    //[[self.view viewWithTag:textField.tag+1] becomeFirstResponder];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    NSMutableArray* paths = [[NSMutableArray alloc] init];
    
    // fill paths of insertion rows here
    
    if( editing )
        [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationBottom];
    else
        [self.tableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationBottom];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [taskArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UITextField *taskTextField;
        CGRect cellRect = cell.frame;
        taskTextField = [[UITextField alloc] initWithFrame:CGRectMake(cellRect.origin.x + 10.0, cellRect.origin.y, cellRect.size.width - 10.0, cellRect.size.height)];
        
        taskTextField.placeholder = @"New Task";
        taskTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        taskTextField.returnKeyType = UIReturnKeyNext;
        taskTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        taskTextField.delegate = self;
        
        //[taskTextField addTarget:self action:@selector(textFieldEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
        [taskTextField addTarget:self action:@selector(textFieldCharacterChanged:) forControlEvents:UIControlEventEditingDidEnd];
        [taskTextField becomeFirstResponder];
        [taskTextField setEnabled: YES];
        
        cell.accessoryView= taskTextField;
        //[cell addSubview:taskTextField];
        
        //[taskTextField becomeFirstResponder];
        //[taskTextField setEnabled: YES];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    [self configureCell:cell forIndexPath:indexPath];
    
    
    //[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    //}
    // Configure the cell...
    
    return cell;
}

-(void)textFieldCharacterChanged:(UITextField *)textField {
    NSString *currentTextField = textField.text;
    
    NSLog(@"replacing Object %@ at index %i with '%@'",[taskArray objectAtIndex:textField.tag],textField.tag,textField.text);
    //textField.text.length > 1
    [taskArray replaceObjectAtIndex:textField.tag withObject:textField.text];
    [self.tableView reloadData];

    
    if (![currentTextField isEqualToString:@""]) {
        if(![[taskArray objectAtIndex:([taskArray count] -1)] isEqualToString:@""]) {
            [taskArray addObject:@""];
            [self.tableView reloadData];
        }
    }
    
    isInTheMiddleOfEditing = NO;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    isInTheMiddleOfEditing = YES;
    NSIndexPath * ip = [self.tableView indexPathForRowAtPoint:textField.frame.origin];
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

- (void)configureCell:(UITableViewCell*)cell forIndexPath:(NSIndexPath*)ip {
    NSString * s = [taskArray objectAtIndex:ip.row];
    NSLog(@"Configuring cell for row:%i with '%@'",ip.row,s);
    UITextField *tf = (UITextField*)cell.accessoryView;
    tf.tag = ip.row;
    [tf setText:s];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    NSMutableIndexSet *indexesToRemove = [NSMutableIndexSet new];
    
    for (int i=0; i < [self.taskArray count] - 1; i++) {
        if([[self.taskArray objectAtIndex:i] isEqualToString:@""]) {
            [indexesToRemove addIndex:i];
        }
    }    
    [self.taskArray removeObjectsAtIndexes:indexesToRemove];
    [self.tableView reloadData];
    //[self.tableView reloadData];
    //    [tasks removeAllObjects];
    //    for (NSString *t in taskArray) {
    //        if (t.text.length>=1) {
    //            [tasks addObject:t.text];
    //        }
    //    }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}
@end