//
//  AddGuideVC.m
//  MemoryManager
//
//  Created by Cormac Quinn on 26/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddGuideVC.h"
#import "Guide.h"
#import "Task.h"
#import "NSManagedObject+CRUD.h"
#import "RepeatVC.h"
#import "AddTaskVC.h"
#import "SoundVC.h"

@interface AddGuideVC () {
    RepeatVC *_repeatVC;
    AddTaskVC *_taskVC;
    SoundVC *_soundVC;
    BOOL setReminder;
    UITextField *titleTextField;
    UITapGestureRecognizer *tap;
    Guide *_guide;
}

@end

@implementation AddGuideVC
@synthesize myDate, tempRepeat, detailItem, tempRepeatBeforeSelection, tempSoundBeforeSelection, tempSound;
@synthesize dateFormatter;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = NSLocalizedString(@"Add Guide", @"Add Guide");
        //self.view.backgroundColor = [UIColor clearColor];
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-grey.png"]];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    tempRepeatBeforeSelection = @"Never";
    tempSoundBeforeSelection = @"Default";
    
    titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(100,12,200,60)];
    titleTextField.delegate = self;
    
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    reminderOn = NO;
    reminderSet = 0;
    
    tap = [[UITapGestureRecognizer alloc] 
           initWithTarget:self
           action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    [tap setCancelsTouchesInView:NO];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(insertNewGuide:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAdd:)];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
	[self.dateFormatter setDateStyle:NSDateFormatterBehavior10_4];
	[self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
	self.dateFormatter = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)cancelAdd:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)dismissKeyboard {
    [titleTextField resignFirstResponder];
}

- (NSDate *)setSecondsToZero:(NSDate *)date{ //takes the date and sets seconds to zero
    unsigned units = NSTimeZoneCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:units fromDate:date];
    
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setYear:year];
    [dateComps setMonth:month];
    [dateComps setDay:day];
    [dateComps setHour:hour];
    [dateComps setMinute:minute];
    [dateComps setSecond:00];
    
    date = [calendar dateFromComponents:dateComps];
    return date;
}

//-(void)saveGuide{
//    NSArray *tasks = _taskVC.taskArray;
//    Guide *g = self.detailItem;
//    g.guideName = titleTextField.text;;
//    if (reminderOn) {
//        myDate = [self setSecondsToZero:myDate];
//        g.guideDate = myDate;
//        g.guideRepeatInterval = tempRepeat;
//    }
//    else {
//        g.guideRepeatInterval = tempRepeatBeforeSelection;
//    }
//    
//    g.guideReminderOn = [NSNumber numberWithBool:reminderOn];
//    g.guideSound = tempSound;
//    for (int i=0; i<[tasks count]; i++) {
//        if(![[tasks objectAtIndex:i] isEqualToString:@""]) {
//            Task *t = [Task createObject];
//            t.taskDate = [NSDate date];
//            t.taskName = [tasks objectAtIndex:i];
//            [g addTasksObject:t];
//        }
//    }
//    [Task saveDatabase];
//    [Guide saveDatabase];
//    
//    [self dismissModalViewControllerAnimated:YES];
//}

- (void)insertNewGuide:(id)sender
{
    NSDate *now = [NSDate date];
    
    int index = ([_taskVC.taskArray count] - 1);
    NSString *lastTask = [_taskVC.taskArray objectAtIndex:index];
            
    if(titleTextField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You must add a title" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else if ((!_taskVC.taskArray||![_taskVC.taskArray count])||(index==0&&[lastTask isEqualToString:@""])) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You must add at least one task" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else if (reminderOn) {
        if ([now compare:myDate]==NSOrderedDescending||[now compare:myDate]==NSOrderedSame) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                            message:@"The date you have choosen is in the past" 
                                                           delegate:self 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles: nil];
            [alert show];
        }
        else {
            NSArray *tasks = _taskVC.taskArray;
            _guide = [Guide createObject];
            _guide.guideName = titleTextField.text;
            _guide.guideCreationDate = [NSDate date];
            myDate = [self setSecondsToZero:myDate];
            _guide.guideDate = myDate;
            _guide.guideRepeatInterval = tempRepeat;
            _guide.guideSound =  tempSound;
            _guide.guideReminderOn = [NSNumber numberWithBool:reminderOn];
            
            for (int i=0; i<[tasks count]; i++) {
                if(![[tasks objectAtIndex:i] isEqualToString:@""]) {
                    Task *t = [Task createObject];
                    t.taskDate = [NSDate date];
                    t.taskName = [tasks objectAtIndex:i];
                    [_guide addTasksObject:t];
                }
            }
            [Task saveDatabase];
            [Guide saveDatabase];
            [self scheduleNotificationForDate:self.myDate withObject:_guide];
            [self dismissModalViewControllerAnimated:YES];
            //[self saveGuide];
        }
    }
    else{
        //[self saveGuide];
        NSArray *tasks = _taskVC.taskArray;
        _guide = [Guide createObject];
        _guide.guideName = titleTextField.text;
        _guide.guideRepeatInterval = tempRepeatBeforeSelection;
        _guide.guideSound =  tempSound;
        _guide.guideReminderOn = [NSNumber numberWithBool:reminderOn];
        for (int i=0; i<[tasks count]; i++) {
            if(![[tasks objectAtIndex:i] isEqualToString:@""]) {
                Task *t = [Task createObject];
                t.taskDate = [NSDate date];
                t.taskName = [tasks objectAtIndex:i];
                [_guide addTasksObject:t];
            }
        }
        [Task saveDatabase];
        [Guide saveDatabase];
        
        [self dismissModalViewControllerAnimated:YES];
    }
}

-(void) scheduleNotificationForDate:(NSDate*)date withObject:(Guide *)guide {
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    localNotification.fireDate = date;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.alertBody = [NSString stringWithFormat:guide.guideName];
    localNotification.alertAction = NSLocalizedString(@"Start Guide", nil);
    localNotification.repeatCalendar = [NSCalendar currentCalendar];
    
    if(tempRepeat==@"Every Day"){
        localNotification.repeatInterval=NSDayCalendarUnit;
        //localNotification.repeatInterval=NSMinuteCalendarUnit;
    }
    else if (tempRepeat==@"Every Week") {
        localNotification.repeatInterval=NSWeekCalendarUnit;
    }
    else if (tempRepeat==@"Every Month") {
        localNotification.repeatInterval=NSMonthCalendarUnit;
    }
    else if (tempRepeat==@"Every Year") {
        localNotification.repeatInterval=NSYearCalendarUnit;
    }
    else {
        localNotification.repeatInterval = 0;
    }
    
    /* Here we set notification sound and badge on the app's icon "-1" 
     means that number indicator on the badge will be decreased by one 
     - so there will be no badge on the icon */
    
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = -1;

    NSManagedObjectID *objID = [guide objectID];
    NSURL *urlID = [objID URIRepresentation];
    NSString *strID = [urlID absoluteString];
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Guide",@"Type", strID, @"ObjectID", nil];
    localNotification.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (reminderOn==NO)
        return 3;
    else
        return 5;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 25) ? NO : YES;
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
    
    if(indexPath.row==0){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //UITextField *titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(150,12,150,40)];
        titleTextField.placeholder = @"Add Title";
        titleTextField.returnKeyType = UIReturnKeyDefault;
        titleTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        titleTextField.textAlignment = UITextAlignmentRight;
        titleTextField.tag = 0;
        [titleTextField setEnabled: YES];
        [cell addSubview:titleTextField];
        cell.textLabel.text = @"Title";
    }
    if(indexPath.row==1) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"Tasks";
        
        int index = ([_taskVC.taskArray count] - 1);
        NSString *lastTask = [_taskVC.taskArray objectAtIndex:index];
        
        if (_taskVC.taskArray==nil||![_taskVC.taskArray count]||index==0) { //not nil would be just !arrayName the
            cell.detailTextLabel.text = @"None";          //second part here checks if the array is not empty
        }
        else {
            if([lastTask isEqualToString:@""]){
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", index];
            }
            else {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [_taskVC.taskArray count]];
            }
        }
    }
    if(indexPath.row==2){
        switch( [indexPath row] ) {
            case 2: {
                UITableViewCell* aCell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
                if(aCell==nil) {
                    aCell = [[UITableViewCell alloc] initWithFrame:CGRectZero]; // reuseIdentifier:@"SwitchCell"
                    aCell.textLabel.text = @"Alert";
                    aCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
                    aCell.accessoryView = switchView;
                    [switchView setOn:reminderOn animated:NO];
                    [switchView addTarget:self action:@selector(reminderSwitchChanged:) forControlEvents:UIControlEventValueChanged];
                }
                [aCell setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1]];
                return aCell;
            }
                break;
        }
        return nil;
    }
    if(indexPath.row==3){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"Date";
        cell.detailTextLabel.text = [self.dateFormatter stringFromDate:myDate];
    }
    if(indexPath.row==4){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"Repeat";
        if (_repeatVC) 
            cell.detailTextLabel.text = _repeatVC.checkedData;
        else {
            cell.detailTextLabel.text = tempRepeatBeforeSelection;
        }
        tempRepeat = cell.detailTextLabel.text;
    }
//    if(indexPath.row==5){
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.textLabel.text = @"Alarm Sound";
//        if (_soundVC) 
//            cell.detailTextLabel.text = _soundVC.checkedData;
//        else {
//            cell.detailTextLabel.text = tempSoundBeforeSelection;
//        }
//        tempSound = cell.detailTextLabel.text;
//    }
    // Configure the cell...
    
    [cell setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1]];
    
    return cell;
}

- (void) reminderSwitchChanged:(id)sender {
    UISwitch* switchControl = sender;
    NSIndexPath* row4ToReload = [NSIndexPath indexPathForRow:4 inSection:0];
    //NSIndexPath* row5ToReload = [NSIndexPath indexPathForRow:5 inSection:0];
    NSArray* rowsToReload = [NSArray arrayWithObjects: row4ToReload, nil];
    NSLog( @"The reminder switch is %@", switchControl.on ? @"ON" : @"OFF" );
    if ([switchControl isOn]){
        reminderOn=YES;
        reminderSet=1;
        myDate = [NSDate date];
        myDate = [self setSecondsToZero:myDate];
        [self.tableView reloadData];
        [self.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationBottom];
    }
    else{
        reminderOn=NO;
        reminderSet=0;
        [self.tableView reloadData];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

/*     USE TO MAKE TITLE CELL EDITABLE?
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
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
 */

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
    if(indexPath.row==0){
    }
    if(indexPath.row==1){
        if(!_taskVC)
            _taskVC = [[AddTaskVC alloc] initWithNibName:@"AddTaskVC" bundle:nil];
        
        [self.navigationController pushViewController:_taskVC animated:YES];
    }
    if(indexPath.row==3){
        [self showDatePicker];
        //UITableViewCell *targetCell = [tableView cellForRowAtIndexPath:indexPath];
        //self.pickerView.date = [self.dateFormatter dateFromString:targetCell.detailTextLabel.text];
        //      [self.view endEditing:YES]; // resign firstResponder if you have any text fields so the keyboard doesn't get in the way
        //      [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES]; // Scroll your row to the top so the user can actually see the row                when interacting with the pickerView
    }
    if (indexPath.row==4) { 
        if(!_repeatVC){
            _repeatVC = [[RepeatVC alloc] initWithStyle:UITableViewStyleGrouped];
            _repeatVC.checkedData = tempRepeatBeforeSelection;
        }
        
        [self.navigationController pushViewController:_repeatVC animated:YES];
    }
    if (indexPath.row==5) { 
        if(!_soundVC){
            _soundVC = [[SoundVC alloc] initWithStyle:UITableViewStyleGrouped];
            _soundVC.checkedData = tempSoundBeforeSelection;
        }
        
        [self.navigationController pushViewController:_soundVC animated:YES];
    }
}

-(void)showDatePicker{
    
    dateSheet = [[UIActionSheet alloc] initWithTitle:nil 
                                            delegate:nil
                                   cancelButtonTitle:nil
                              destructiveButtonTitle:nil
                                   otherButtonTitles:nil];
    
    [dateSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    CGRect pickerFrame = CGRectMake(0, 44, 0, 0);
    
    theDatePicker = [[UIDatePicker alloc] initWithFrame:pickerFrame];
    [theDatePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    theDatePicker.date = [self.dateFormatter dateFromString:cell.detailTextLabel.text];
    theDatePicker.minuteInterval = 60/12;
    theDatePicker.minimumDate = [NSDate date];
    
    [dateSheet addSubview:theDatePicker];
    
    UIToolbar *controlToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, dateSheet.bounds.size.width, 44)];
    
    [controlToolBar setBarStyle:UIBarStyleBlack];
    [controlToolBar sizeToFit];
    
    UIButton *doneButton = [UIButton buttonWithType:102];
    [doneButton setFrame: CGRectMake(260, 5, 80.0, 40.0)];
    [doneButton setTitle: @"Done" forState: UIControlStateNormal];
    [doneButton addTarget:self action:@selector(dismissDateSet) forControlEvents:UIControlEventTouchUpInside];
    [controlToolBar addSubview:doneButton];
    
    UIButton *todayButton = [UIButton buttonWithType:102];
    [todayButton setFrame: CGRectMake(10, 5, 80.0, 40.0)];
    [todayButton setTitle: @"Today" forState: UIControlStateNormal];
    [todayButton addTarget:self action:@selector(setToToday) forControlEvents:UIControlEventTouchUpInside];
    [todayButton setTintColor:[UIColor darkGrayColor]];
    [controlToolBar addSubview:todayButton];
    
    [dateSheet addSubview:controlToolBar];
    [dateSheet showInView:self.view];
    [dateSheet setBounds:CGRectMake(0, 0, 320, 485)];
    
    [theDatePicker addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
}

-(void)setToToday{
    theDatePicker.date = [NSDate date];
}

- (IBAction)valueChanged:(id)sender {
    
    NSArray *listOfViews = [dateSheet subviews];  //an array of the views
    
    for(UIView *subView in listOfViews){
        if([subView isKindOfClass:[UIDatePicker class]]){  //enurmation through that array to find the datepicker
            self.myDate = [(UIDatePicker *)subView date];   //set date to that of the datepicker
        }
    }
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	cell.detailTextLabel.text = [self.dateFormatter stringFromDate:myDate];
}

-(void)dismissDateSet{
    
    NSArray *listOfViews = [dateSheet subviews];
    
    for(UIView *subView in listOfViews){
        if([subView isKindOfClass:[UIDatePicker class]]){
            self.myDate = [(UIDatePicker *)subView date];
        }
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	cell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.myDate];
    
    [dateSheet dismissWithClickedButtonIndex:0 animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end