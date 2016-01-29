//
//  ReminderDetailVC.m
//  MemoryManager
//
//  Created by Cormac Quinn on 20/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ReminderDetailVC.h"
#import "Reminder.h"
#import "ViewPictureVC.h"
#import "QuartzCore/QuartzCore.h"

@interface ReminderDetailVC ()

@end

@implementation ReminderDetailVC
@synthesize imageView;
@synthesize fullImageButton;
@synthesize todaysDateLabel;
@synthesize playAudioButton;
@synthesize reminderNameLabel = _reminderNameLabel;
@synthesize reminderDateLabel = _reminderDate;
@synthesize doneButton;
@synthesize backgroundLabel;
@synthesize detailItem = _detailItem;
@synthesize dateFormatter, myDate, soundFilePath, playTimer, playbackTimeLabel, playbackSlider, playbackTotalTimeLabel, pictureFilePath;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.reminderNameLabel.text = [[self.detailItem valueForKey:@"reminderName"] description];
        myDate = [self.detailItem valueForKey:@"reminderDate"];
        self.reminderDateLabel.text = [self.dateFormatter stringFromDate:myDate];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    pictureFilePath = [[self.detailItem valueForKey:@"reminderPicture"] description];
    BOOL pictureFileExists = [[NSFileManager defaultManager] fileExistsAtPath:pictureFilePath];
    if (pictureFileExists) {
        fullImageButton.hidden = NO;
        NSData *imageData = [[NSData alloc] initWithContentsOfFile:pictureFilePath];
        UIImage *image = [UIImage imageWithData: imageData];
        imageView.image = image;
    }
    else {
        fullImageButton.hidden = YES;
        imageView.image = [UIImage imageNamed:@"placeholderImage.jpeg"];
    }
    
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateStyle:NSDateFormatterFullStyle];
    NSString *temp = @"Today is ";
    temp=[temp stringByAppendingString:[df stringFromDate:[NSDate date]]];
    temp = [temp substringToIndex:[temp length] - 5];
    todaysDateLabel.text = temp;
    
    soundFilePath = [[self.detailItem valueForKey:@"reminderAudio"] description];
    BOOL soundFileExists = [[NSFileManager defaultManager] fileExistsAtPath:soundFilePath];
    playAudioButton.hidden=YES;
    if (soundFileExists) {
        playAudioButton.hidden=NO;
        NSError *error = nil;
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        
        audioPlayer = [[AVAudioPlayer alloc] 
                       initWithContentsOfURL:soundFileURL                                    
                       error:&error];
        
        audioPlayer.delegate = self;
        [audioPlayer prepareToPlay];
    }
    else {
        playAudioButton.hidden=YES;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        //self.title = NSLocalizedString(@"Reminder", @"Reminder");
        //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title =[[self.detailItem valueForKey:@"reminderName"] description];
    
    backgroundLabel.layer.borderColor = [UIColor blackColor].CGColor;
    backgroundLabel.layer.borderWidth = 2.0;
    
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
    doneButton.clipsToBounds = YES;
    
    CAGradientLayer *layer2 = [CAGradientLayer layer];
    NSArray *colors2 = [NSArray arrayWithObjects:
                       (id)[UIColor colorWithRed:224.0/255.0 green:176.0/255.0 blue:255.0/255.0 alpha:1].CGColor,
                       (id)[UIColor colorWithRed:224.0/255.0 green:176.0/255.0 blue:255.0/255.0 alpha:1].CGColor,
                       nil];
    [layer2 setColors:colors2];
    [layer2 setFrame:playAudioButton.bounds];
    [playAudioButton.layer insertSublayer:layer2 atIndex:0];
    playAudioButton.layer.cornerRadius = 10.0f;
    playAudioButton.layer.borderColor = [UIColor blackColor].CGColor;
    playAudioButton.layer.borderWidth = 1.5f;
    playAudioButton.clipsToBounds = YES;
    
//    playAudioButton.layer.borderColor = [UIColor blackColor].CGColor;
//    playAudioButton.layer.borderWidth = 1.5f;
//    playAudioButton.clipsToBounds = YES;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
	[self.dateFormatter setDateStyle:NSDateFormatterLongStyle];
	[self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    if (self.detailItem) {
        self.reminderNameLabel.text = [[self.detailItem valueForKey:@"reminderName"] description];
        myDate = [self.detailItem valueForKey:@"reminderDate"];
        self.reminderDateLabel.text = [self.dateFormatter stringFromDate:myDate];
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setReminderNameLabel:nil];
    [self setReminderDateLabel:nil];
    [self setPlayAudioButton:nil];
    [self setImageView:nil];
    [self setTodaysDateLabel:nil];
    [self setFullImageButton:nil];
    [self setBackgroundLabel:nil];
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
    [self dismissModalViewControllerAnimated:YES];
}

-(void)updatePlayTimer{
    
    NSTimeInterval currentTime = audioPlayer.currentTime;
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:currentTime];
    NSDateFormatter *timeDateFormatter = [[NSDateFormatter alloc] init];
    [timeDateFormatter setDateFormat:@"m:ss"];
    [timeDateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    NSString *timeString=[timeDateFormatter stringFromDate:timerDate];
    playbackTimeLabel.text = timeString;
    //playbackTimeLabel.text = [NSString stringWithFormat:@"%.0f", audioPlayer.currentTime];
    
    NSTimeInterval timeLeft = audioPlayer.duration;
    //NSTimeInterval timeLeft = audioPlayer.duration - audioPlayer.currentTime; This will show hong long is left
    NSDate *timerDate2 = [NSDate dateWithTimeIntervalSince1970:timeLeft];
    NSString *timeString2=[timeDateFormatter stringFromDate:timerDate2];
    playbackTotalTimeLabel.text = timeString2;
    
    NSString *str = [NSString stringWithFormat:@"%f", audioPlayer.currentTime];
    NSLog(@"%@", str);
    playbackSlider.value = audioPlayer.currentTime;
    
    if(!audioPlayer.playing){
        NSLog(@"Audio is stopped");
    }
}

- (IBAction)playAudio:(UIButton *)sender {
    NSError *error = nil;
    
    if (error)
        NSLog(@"Error: %@", [error localizedDescription]);
    else
        [audioPlayer play];
    
    audioPlayer.currentTime = 0;
    playbackSlider.maximumValue = audioPlayer.duration;
    [self showPlaybackActionSheet];
    [playTimer invalidate];
    playTimer = nil;
    playTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(updatePlayTimer) userInfo:nil repeats:YES];
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

- (IBAction)slide:(UISlider *)sender {
    audioPlayer.currentTime = playbackSlider.value;
}

- (IBAction)showFullPicture:(UIButton *)sender {
    
    ViewPictureVC *viewPictureVC = [ViewPictureVC new];
    viewPictureVC.picture = imageView.image;
    UINavigationController *pictureViewNav = [[UINavigationController alloc] initWithRootViewController:viewPictureVC];
    [self presentModalViewController:pictureViewNav animated:YES];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog (@"audioPlayerDidFinishPlaying:successfully");
    [playTimer invalidate];
    playTimer = nil;
    [playbackSheet dismissWithClickedButtonIndex:nil animated:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet==playbackSheet) {
        
        if(buttonIndex==0){
            
            if (audioPlayer.playing) {
                [audioPlayer stop];
                [playTimer invalidate];
                playTimer =nil;
            }
        }
    }
}

@end
