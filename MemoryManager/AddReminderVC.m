//
//  AddReminderVC.m
//  MemoryManager
//
//  Created by Cormac Quinn on 02/08/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddReminderVC.h"
#import "NSManagedObject+CRUD.h"
#import "Reminder.h"
#import "RepeatVC.h"
#import "AddAudioVC.h"
#import "AddPictureVC.h"
#import "SoundVC.h"

@interface AddReminderVC (){
    RepeatVC *_repeatVC;
    AddAudioVC *_audioVC;
    AddPictureVC *_pictureVC;
    SoundVC *_soundVC;
    UITextField *titleTextField;
    UITapGestureRecognizer *tap;
    Reminder *_reminder;
}

@end

@implementation AddReminderVC

@synthesize myDate, tempRepeat, dateFormatter, tempRepeatBeforeSelection, tempSoundBeforeSelection, tempSound;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = NSLocalizedString(@"Add Reminder", @"Add Reminder");
        //self.view.backgroundColor = [UIColor clearColor];
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-grey.png"]];
        // Custom initialization
    }
    return self;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
	[self.dateFormatter setDateStyle:NSDateFormatterBehavior10_4];
	[self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    //[self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    myDate = [NSDate date];
    
    myDate = [self setSecondsToZero:myDate];
    
    tempRepeatBeforeSelection = @"Never";
    tempSoundBeforeSelection = @"Default";
    titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(100,12,200,60)];
    titleTextField.delegate = self;
    
    tap = [[UITapGestureRecognizer alloc] 
           initWithTarget:self
           action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    [tap setCancelsTouchesInView:NO];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(insertNewReminder:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAdd:)];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.dateFormatter = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)cancelAdd:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)dismissKeyboard {
    [titleTextField resignFirstResponder];
}

- (void)insertNewReminder:(id)sender
{
    NSDate *now = [NSDate date];
    
    if(titleTextField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                        message:@"You must add a title" 
                                                       delegate:self 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles: nil];
        [alert show];
    }
    else if (_audioVC.audioSwitch.on&&!_audioVC.hasRecordingTakenPlace) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                        message:@"There is no recording" 
                                                       delegate:self 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles: nil];
        [alert show];
    }
    else if ([now compare:myDate]==NSOrderedDescending||[now compare:myDate]==NSOrderedSame) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                        message:@"The date you have choosen is in the past" 
                                                       delegate:self 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles: nil];
        [alert show];
    }
    else {
        _reminder = [Reminder createObject];
        _reminder.reminderName = titleTextField.text;
        _reminder.reminderAudio = _audioVC.soundFilePath;
        _reminder.reminderPicture = _pictureVC.pictureFilePath;

        myDate = [self setSecondsToZero:myDate]; //is going to set the seconds to zero so it alerts on time
        
        _reminder.reminderDate = self.myDate;
        _reminder.reminderRepeatInterval = tempRepeat;
        _reminder.reminderSound = tempSound;
        
        [Reminder saveDatabase];
        
        [self scheduleNotificationForDate:self.myDate withObject:_reminder];
        
        [self dismissModalViewControllerAnimated:YES];
    }
}

-(void) scheduleNotificationForDate:(NSDate*)date withObject:(Reminder *)reminder {
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    localNotification.fireDate = date;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.alertBody = [NSString stringWithFormat:reminder.reminderName];
    localNotification.alertAction = NSLocalizedString(@"View Reminder", nil);
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
    
    NSManagedObjectID *objID = [reminder objectID];
    NSURL *urlID = [objID URIRepresentation];
    NSString *strID = [urlID absoluteString];
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Reminder",@"Type", strID, @"ObjectID", nil];
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
    if(indexPath.row==0){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        cell.textLabel.text = @"Audio Message";
        cell.detailTextLabel.text = _audioVC.audioSwitch.on ? @"Yes": @"No";
    }
    if(indexPath.row==2) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"Picture";
        cell.detailTextLabel.text = _pictureVC.pictureSwitch.on ? @"Yes": @"No";
    }
    if(indexPath.row==3){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"Alert";
        cell.detailTextLabel.text = [self.dateFormatter stringFromDate:myDate];
    }
    if(indexPath.row==4){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"Repeat";
        if (_repeatVC) {
            cell.detailTextLabel.text = _repeatVC.checkedData;
        } else 
            cell.detailTextLabel.text = tempRepeatBeforeSelection;
        
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

    [cell setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1]];
    
    return cell;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==1){
        if(!_audioVC)
            _audioVC = [[AddAudioVC alloc] initWithNibName:@"AddAudioVC" bundle:nil];
        
        [self.navigationController pushViewController:_audioVC animated:YES];
    }
    if(indexPath.row==2){
        if(!_pictureVC)
            _pictureVC = [[AddPictureVC alloc] initWithNibName:@"AddPictureVC" bundle:nil];
        
        [self.navigationController pushViewController:_pictureVC animated:YES];
    }
    if(indexPath.row==3){
        [self showDatePicker];
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
    
    NSArray *listOfViews = [dateSheet subviews];
    for(UIView *subView in listOfViews){
        if([subView isKindOfClass:[UIDatePicker class]]){
            self.myDate = [(UIDatePicker *)subView date];
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