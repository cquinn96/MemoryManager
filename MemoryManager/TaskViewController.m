//
//  TaskViewController.m
//  MemoryManager
//
//  Created by Cormac Quinn on 26/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TaskViewController.h"
#import "Task.h"
#import <QuartzCore/QuartzCore.h>

@interface TaskViewController ()

@end

@implementation TaskViewController
@synthesize stepLabel;
@synthesize doneButton;
@synthesize taskNameLabel;
@synthesize selectedGuide, listItems, taskList, detailItem, myString, aString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"taskDate" ascending:YES];
    self.title = detailItem.guideName;
    
    //doneButton.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
//    doneButton.backgroundColor = [UIColor redColor];
//    doneButton.layer.borderColor = [UIColor blackColor].CGColor;
//    doneButton.layer.borderWidth = 0.5f;
//    doneButton.layer.cornerRadius = 10.0f;
    
    CAGradientLayer *layer = [CAGradientLayer layer];
    NSArray *colors = [NSArray arrayWithObjects:
                       (id)[UIColor colorWithRed:255.0/255.0 green:204.0/255.0 blue:0.0/255.0 alpha:1].CGColor,
                       (id)[UIColor colorWithRed:255.0/255.0 green:204.0/255.0 blue:0.0/255.0 alpha:1].CGColor,
                       nil];
    [layer setColors:colors];
    [layer setFrame:doneButton.bounds];
    [doneButton.layer insertSublayer:layer atIndex:0];
    doneButton.layer.cornerRadius = 10.0f;
    doneButton.layer.borderColor = [UIColor blackColor].CGColor;
    doneButton.layer.borderWidth = 1.5f;
    doneButton.clipsToBounds = YES; // Important!
    
    
    aString = @" of ";
    count = 0;
    self.taskList = [[NSSet alloc] initWithSet:self.detailItem.tasks];
    self.listItems = [[[NSArray alloc] initWithArray:[self.taskList allObjects]] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
//    taskNameLabel.layer.cornerRadius = 10; //rounds edges of label
//    taskNameLabel.clipsToBounds = YES;
    
    taskNameLabel.layer.borderColor = [UIColor blackColor].CGColor;
    taskNameLabel.layer.borderWidth = 2.0;
    
    [self setUp];
    
    // Do any additional setup after loading the view from its nib.
}
-(void) setUp{
    myString = @"Task ";
    myString=[myString stringByAppendingString:[NSString stringWithFormat:@"%i", count+1]];
    myString=[myString stringByAppendingString:[NSString stringWithFormat:@"%@", self.aString]];
    myString=[myString stringByAppendingString:[NSString stringWithFormat:@"%i", [self.listItems count]]];
    stepLabel.text = myString;
    Task *t = [self.listItems objectAtIndex:count];
    taskNameLabel.text = t.taskName;
     count++;
}
- (void)viewDidUnload
{
    [self setTaskNameLabel:nil];
    [self setStepLabel:nil];
    [self setDoneButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)doneButton:(UIButton *)sender {
    if (count==[self.listItems count]) {
        [self dismissModalViewControllerAnimated:YES];
        UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"Guide Completed"
                                                        delegate:self cancelButtonTitle:@"OK" 
                                               otherButtonTitles:nil];
        [alert show];
    }
    else {
        [self setUp];
    }
}
@end
