//
//  AddAudioVC.h
//  MemoryManager
//
//  Created by Cormac Quinn on 02/08/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "Reminder.h"

@interface AddAudioVC : UIViewController <AVAudioPlayerDelegate, AVAudioRecorderDelegate, UIActionSheetDelegate> {
    AVAudioPlayer *audioPlayer;
    AVAudioRecorder *audioRecorder;
    NSURL *recordedTmpFile;
    UIActionSheet *playbackSheet;
    UIActionSheet *deleteSheet;
    UIActionSheet *recordSheet;
    BOOL hasRecordingTakenPlace;
    BOOL areWeEditing;
    UIAlertView  *deleteAlert;
}

- (IBAction)recordButtonPressed:(UIButton *)sender;
- (IBAction)playButtonPressed:(UIButton *)sender;
- (IBAction)deleteButtonPressed:(UIButton *)sender;
- (IBAction)audioSwitchedChanged:(UISwitch *)sender;
- (IBAction)stopButtonPressed:(UIButton *)sender;
- (IBAction)stopPlaying:(UIButton *)sender;
- (IBAction)slide:(UISlider *)sender;

@property BOOL hasRecordingTakenPlace;
@property BOOL areWeEditing;
@property (nonatomic, retain) NSString *dateString;
@property (nonatomic, retain) NSTimer *playTimer;
@property (nonatomic, retain) NSTimer *recTimer;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) UILabel *playbackTimeLabel;
@property (nonatomic, retain) UILabel *playbackTotalTimeLabel;
@property (nonatomic, retain) UISlider *playbackSlider;
@property (nonatomic, retain) UILabel *recordingTimeLabel2;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *recStateLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *audioMessageLabel;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *stopPlayingButton;
@property (nonatomic, retain) NSString *soundFilePath;
@property (nonatomic, retain) Reminder *detailItem;
@property (nonatomic, retain) UISwitch *audioSwitch;


@end
