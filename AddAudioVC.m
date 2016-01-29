//
//  AddAudioVC.m
//  MemoryManager
//
//  Created by Cormac Quinn on 02/08/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddAudioVC.h"
#import "Reminder.h"

@interface AddAudioVC (){
    int rec_time;
}

@end

@implementation AddAudioVC
@synthesize audioSwitch;
//@synthesize recordingTimeLabel;
@synthesize playbackTimeLabel;
@synthesize playbackSlider;
@synthesize recordButton;
@synthesize playButton;
@synthesize deleteButton;
@synthesize audioMessageLabel;
@synthesize stopButton;
@synthesize stopPlayingButton;
@synthesize soundFilePath;
@synthesize recStateLabel;
@synthesize dateFormatter, startDate, recTimer, playTimer, playbackTotalTimeLabel, recordingTimeLabel2, dateString, hasRecordingTakenPlace, detailItem, areWeEditing;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Add Audio", @"Add Audio");
        //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    audioSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    
    soundFilePath = [[self.detailItem valueForKey:@"reminderAudio"] description];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:soundFilePath];
    
    if (fileExists) {
        [audioSwitch setOn:YES animated:NO];
        hasRecordingTakenPlace=YES;
        areWeEditing=YES;
    }
    else {
        [recordButton setHidden:YES];
        [playButton setHidden:YES];
        [deleteButton setHidden:YES];
        [audioSwitch setOn:NO animated:NO];
        hasRecordingTakenPlace=NO;
        areWeEditing=NO;
    }
    
    [stopButton setHidden:YES];
    [stopPlayingButton setHidden:YES];
    recStateLabel.hidden = YES;
    //recordingTimeLabel.hidden = YES;
    self.dateFormatter = [[NSDateFormatter alloc] init];
    //[self.dateFormatter setTimeStyle:NSDateFormatterBehavior10_4];
    // [self.dateFormatter setDateStyle: NSDateFormatterShortStyle];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd_HH-mm-ss"];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setRecordButton:nil];
    [self setPlayButton:nil];
    [self setDeleteButton:nil];
    [self setAudioSwitch:nil];
    [self setAudioMessageLabel:nil];
    [self setStopButton:nil];
    [self setStopPlayingButton:nil];
    //[self setRecordingTimeLabel:nil];
    [self setRecStateLabel:nil];
    [self setPlaybackSlider:nil];
    [self setPlaybackTimeLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)recordButtonPressed:(UIButton *)sender {
    if (hasRecordingTakenPlace==YES) {
        UIAlertView *replaceRecordingAlert = [[UIAlertView alloc]  initWithTitle:@"Warning"
                                                                         message:@"You are about to overwrite your last recording"
                                                                        delegate:self
                                                               cancelButtonTitle:@"Cancel"
                                                               otherButtonTitles:@"Start Recording", nil];
        [replaceRecordingAlert show];
    }
    else {
        [self createFileToRecord];
        [self startRecording];
        areWeEditing=NO;
    }
}

-(void)startRecording{
    
    NSError *error = nil;
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: &error];
    [audioSession setActive:YES error:&error];
    recStateLabel.hidden = NO;
    //recordingTimeLabel.hidden = NO;
    
    BOOL audioHWAvailable = audioSession.inputIsAvailable;
    if (!audioHWAvailable) {
        UIAlertView *cantRecordAlert =  [[UIAlertView alloc] initWithTitle:@"Warning"
                                                                   message:@"No mic available"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil];
        [cantRecordAlert show];
        return;
    }
    
    if (!audioRecorder.recording)
    {
        [recordButton setHidden:YES];
        [stopButton setHidden:NO];
        [audioRecorder record];
        recStateLabel.text = @"Recording: 0:00";
        startDate = [NSDate date];
        hasRecordingTakenPlace=YES;
        rec_time = 0;
        // Create the recording timer that fires every 1 second
        recTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                    target:self
                                                  selector:@selector(updateRecTimer)
                                                  userInfo:nil
                                                   repeats:YES];
        //[self showRecordActionSheet];
    }
}

//-(void)showRecordActionSheet{
//    recordSheet = [[UIActionSheet alloc]   initWithTitle:nil 
//                                                delegate:nil
//                                       cancelButtonTitle:@"Cancel"
//                                  destructiveButtonTitle:nil
//                                       otherButtonTitles:nil];
//    
//    [recordSheet setActionSheetStyle:UIActionSheetStyleAutomatic];
//    
//    CGRect frameRecLabel = CGRectMake(20.0, -200.0, 40.0, 20.0);                     //time label
//    recordingTimeLabel2 = [[UILabel alloc] initWithFrame:frameRecLabel];
//    recordingTimeLabel2.text = @"0:00";
//    recordingTimeLabel2.textColor=[UIColor whiteColor];
//    recordingTimeLabel2.font=[UIFont systemFontOfSize:16];
//    recordingTimeLabel2.backgroundColor=[UIColor clearColor];
//    
//    [recordSheet addSubview:recordingTimeLabel2];
//    [recordSheet showFromToolbar:(UIToolbar *)self.view];
//}

- (void)updateRecTimer
{
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:startDate];
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *timeDateFormatter = [[NSDateFormatter alloc] init];
    [timeDateFormatter setDateFormat:@"m:ss"];
    [timeDateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    NSString *temp = @"Recording: ";
    recStateLabel.text = [temp stringByAppendingString:[timeDateFormatter stringFromDate:timerDate]];
    //recordingTimeLabel.text = [timeDateFormatter stringFromDate:timerDate];
    
    if (rec_time == 300) {
        [self stopButtonPressed:nil];
        UIAlertView  *tooLongAlert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"Recording finished"                  
                                                               delegate:nil 
                                                      cancelButtonTitle:@"OK" 
                                                      otherButtonTitles:nil];
        [tooLongAlert show];
    }
    rec_time++;
}

-(void)updatePlayTimer{
    
    NSTimeInterval currentTime = audioPlayer.currentTime;
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:currentTime];
    NSDateFormatter *timeDateFormatter = [[NSDateFormatter alloc] init];
    [timeDateFormatter setDateFormat:@"m:ss"];
    [timeDateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    //NSString *timeString=[timeDateFormatter stringFromDate:timerDate];
    playbackTimeLabel.text = [timeDateFormatter stringFromDate:timerDate];
    
    NSTimeInterval timeLeft = audioPlayer.duration;
    //NSTimeInterval timeLeft = audioPlayer.duration - audioPlayer.currentTime; This will show hong long is left
    NSDate *timerDate2 = [NSDate dateWithTimeIntervalSince1970:timeLeft];
    //NSString *timeString2=[timeDateFormatter stringFromDate:timerDate2];
    playbackTotalTimeLabel.text = [timeDateFormatter stringFromDate:timerDate2];
    
    NSString *str = [NSString stringWithFormat:@"%f", audioPlayer.currentTime];
    NSLog(@"%@", str);
    playbackSlider.value = audioPlayer.currentTime;
    
    if(!audioPlayer.playing){
        [stopPlayingButton setHidden:YES];
        [playButton setHidden:NO];
        NSLog(@"Audio is stopped");
    }
}

- (IBAction)playButtonPressed:(UIButton *)sender {
    if (!audioRecorder.recording)
    {
        [playButton setHidden:YES];
        [stopPlayingButton setHidden:NO];
        
        NSError *error = nil;
        
        if(areWeEditing){
            NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
            audioPlayer = [[AVAudioPlayer alloc] 
                           initWithContentsOfURL:soundFileURL                                    
                           error:&error];
        }
        else {
            audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioRecorder.url error:&error];
        }
        audioPlayer.delegate = self;
        
        if (error)
            NSLog(@"Error: %@", [error localizedDescription]);
        else
            [audioPlayer play];
        
        audioPlayer.currentTime = 0;
        playbackSlider.maximumValue = audioPlayer.duration;
        [self showPlaybackActionSheet];
        [playTimer invalidate];
        playTimer = nil;
        playTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 
                                                     target:self 
                                                   selector:@selector(updatePlayTimer) 
                                                   userInfo:nil 
                                                    repeats:YES];
    }
}

-(void)showPlaybackActionSheet{
    playbackSheet = [[UIActionSheet alloc] initWithTitle:@" " 
                                                delegate:self
                                       cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                       otherButtonTitles:nil];
    
    [playbackSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
    
    CGRect frame = CGRectMake(50.0, 10.0, 220.0, 10.0);
    playbackSlider = [[UISlider alloc] initWithFrame:frame];
    [playbackSlider addTarget:self action:@selector(slide:) forControlEvents:UIControlEventValueChanged];
    [playbackSlider setBackgroundColor:[UIColor clearColor]];
    playbackSlider.transform = CGAffineTransformMakeScale(0.8, 0.8);
    playbackSlider.minimumValue = 0.0;
    playbackSlider.maximumValue = audioPlayer.duration;
    playbackSlider.continuous = YES;
    
    [playbackSheet sizeToFit];
    [playbackSheet addSubview:playbackSlider];
    
    CGRect frameLabel = CGRectMake(28.0, 10.0, 40.0, 20.0);                     //time label
    playbackTimeLabel = [[UILabel alloc] initWithFrame:frameLabel];
    playbackTimeLabel.text = @"0:00";
    playbackTimeLabel.textColor=[UIColor whiteColor];
    playbackTimeLabel.font=[UIFont systemFontOfSize:16];
    playbackTimeLabel.backgroundColor=[UIColor clearColor];
    
    [playbackSheet addSubview:playbackTimeLabel];
    
    // update your UI with timeLeft
    CGRect frameLabel2 = CGRectMake(260.0, 10.0, 40.0, 20.0);                   //time left label
    playbackTotalTimeLabel = [[UILabel alloc] initWithFrame:frameLabel2];
    playbackTotalTimeLabel.text = @"0:00";
    playbackTotalTimeLabel.textColor=[UIColor whiteColor];
    playbackTotalTimeLabel.font=[UIFont systemFontOfSize:16];
    playbackTotalTimeLabel.backgroundColor=[UIColor clearColor];
    
    [playbackSheet addSubview:playbackTotalTimeLabel];
    
    [playbackSheet showInView:self.view];
}

- (IBAction)deleteButtonPressed:(UIButton *)sender {
    deleteSheet = [[UIActionSheet alloc] initWithTitle:nil 
                                              delegate:self
                                     cancelButtonTitle:@"Cancel"
                                destructiveButtonTitle:@"Delete"
                                     otherButtonTitles:nil];
    
    [deleteSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
    [deleteSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet==deleteSheet) {
        if (buttonIndex==0) {
            [playButton setHidden:YES];
            [stopPlayingButton setHidden:YES];
            [deleteButton setHidden:YES];
            hasRecordingTakenPlace=NO;
            if (areWeEditing) {
                NSError *error = nil;
                NSFileManager *fileManager = [NSFileManager defaultManager];
                BOOL fileExists = [fileManager fileExistsAtPath:soundFilePath];
                if (fileExists) {
                    BOOL success = [fileManager removeItemAtPath:soundFilePath error:&error];
                    if (!success) NSLog(@"Error: %@", [error localizedDescription]);
                }
            }
            else {
                [audioRecorder deleteRecording];
            }
            areWeEditing=NO;
        }
    }
    else {
        if(buttonIndex==0){
            stopPlayingButton.hidden = YES;
            playButton.hidden = NO;
            if (audioPlayer.playing) {
                [audioPlayer stop];
                [playTimer invalidate];
                playTimer =nil;
            }
        }
    }
}

- (void)createFileToRecord {
    NSError *error = nil;
    
    NSArray *dirPaths;
    NSString *docsDir;
    
    dateString = [self.dateFormatter stringFromDate:[NSDate date]];
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSString *filePath = [docsDir stringByAppendingPathComponent:dateString];
    soundFilePath = filePath;
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    NSDictionary *recordSettings = [NSDictionary 
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:AVAudioQualityMin],
                                    AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:16], 
                                    AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 2], 
                                    AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:44100.0], 
                                    AVSampleRateKey,
                                    nil];
    
    audioRecorder = [[AVAudioRecorder alloc] initWithURL:soundFileURL
                                                settings:recordSettings
                                                   error:&error];
    audioRecorder.delegate = self;
    
    if (error)
        NSLog(@"Error: %@", [error localizedDescription]);
    else 
        [audioRecorder prepareToRecord];
}

- (IBAction)audioSwitchChanged{
    
    if ([audioSwitch isOn]) {
        if (hasRecordingTakenPlace) {
            [self createFileToRecord];
        }
        [recordButton setHidden:NO];
    }
    else {
        NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString* filePath = [documentsPath stringByAppendingPathComponent:dateString];
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
        if (hasRecordingTakenPlace) {
            if (fileExists) {
                deleteAlert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                         message:@"Setting this switch to off will delete the current recording"                  
                                                        delegate:self 
                                               cancelButtonTitle:@"Cancel" 
                                               otherButtonTitles:@"OK", nil];
                [deleteAlert show];
            }
            else {
                [self hideAllButtons];
            }
        }
        else {
            [self hideAllButtons];
            if (fileExists) {
                [audioRecorder deleteRecording];
                hasRecordingTakenPlace=NO;
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView==deleteAlert) {
        if (buttonIndex == 1){
            [self hideAllButtons];
            if(areWeEditing){
                NSError *error = nil;
                NSFileManager *fileManager = [NSFileManager defaultManager];
                BOOL fileExists = [fileManager fileExistsAtPath:soundFilePath];
                if (fileExists) {
                    BOOL success = [fileManager removeItemAtPath:soundFilePath error:&error];
                    if (!success) NSLog(@"Error: %@", [error localizedDescription]);
                }
            }
            else {
                [audioRecorder deleteRecording];
            }
            hasRecordingTakenPlace=NO;
            areWeEditing=NO;
        }
        else
            [audioSwitch setOn:YES animated:NO];
    }
    else {  // this is the re-record alert view
        if (buttonIndex==1) {
            if(areWeEditing){
                NSError *error = nil;
                NSFileManager *fileManager = [NSFileManager defaultManager];
                BOOL fileExists = [fileManager fileExistsAtPath:soundFilePath];
                if (fileExists) {
                    BOOL success = [fileManager removeItemAtPath:soundFilePath error:&error];
                    if (!success) NSLog(@"Error: %@", [error localizedDescription]);
                }
            }
            else {
                [audioRecorder deleteRecording];
            }
            areWeEditing=NO;
            playButton.hidden=YES;
            deleteButton.hidden=YES;
            //hasRecordingTakenPlace=YES;
            [self createFileToRecord];
            [self startRecording];
        }
    }
}

- (IBAction)stopButtonPressed:(UIButton *)sender {
    [stopPlayingButton setHidden:YES];
    [stopButton setHidden:YES];
    [recordButton setHidden:NO];
    [playButton setHidden:NO];
    [deleteButton setHidden:NO];
    recStateLabel.hidden = YES;
    //recordingTimeLabel.hidden = YES;
    
    if (audioRecorder.recording)
        [audioRecorder stop];
    
    [recTimer invalidate];
    recTimer = nil;
    //[self updateRecTimer];
}

- (IBAction)stopPlaying:(UIButton *)sender {
    [stopPlayingButton setHidden:YES];
    [playButton setHidden:NO];
    if (audioPlayer.playing) {
        [audioPlayer stop];
        [playTimer invalidate];
        playTimer =nil;
    }
}

- (IBAction)slide:(UISlider *)sender {
    audioPlayer.currentTime = playbackSlider.value;
}

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    NSLog (@"audioRecorderDidFinishRecording:successfully:");
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog (@"audioPlayerDidFinishPlaying:successfully:");
    [playTimer invalidate];
    playTimer = nil;
    [stopPlayingButton setHidden:YES];
    [playButton setHidden:NO];
    [playbackSheet dismissWithClickedButtonIndex:nil animated:YES];
}

-(void)hideAllButtons{
    [recordButton setHidden:YES];
    [playButton setHidden:YES];
    [deleteButton setHidden:YES];
    [stopButton setHidden:YES];
    [stopPlayingButton setHidden:YES];
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SwitchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
    }
    cell.textLabel.text = @"Audio Message";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryView = audioSwitch;
    [audioSwitch addTarget:self action:@selector(audioSwitchChanged) forControlEvents:UIControlEventValueChanged];
    
    [cell setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1]];
    
    return cell;
}

@end

