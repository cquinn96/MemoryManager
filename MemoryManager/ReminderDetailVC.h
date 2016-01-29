//
//  ReminderDetailVC.h
//  MemoryManager
//
//  Created by Cormac Quinn on 20/07/2012.
//  Copyright (c) 2012 Cormac Quinn. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface ReminderDetailVC : UIViewController <AVAudioPlayerDelegate, UIActionSheetDelegate>{
    AVAudioPlayer *audioPlayer;
    UIActionSheet *playbackSheet;
}

@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UILabel *backgroundLabel;
@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *reminderNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *reminderDateLabel;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSDate *myDate;
@property (nonatomic, retain) NSString *soundFilePath;
@property (nonatomic, retain) NSString *pictureFilePath;
@property (weak, nonatomic) IBOutlet UIButton *playAudioButton;
@property (nonatomic, retain) NSTimer *playTimer;
@property (nonatomic, retain) UILabel *playbackTimeLabel;
@property (nonatomic, retain) UILabel *playbackTotalTimeLabel;
@property (nonatomic, retain) UISlider *playbackSlider;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *fullImageButton;

@property (weak, nonatomic) IBOutlet UILabel *todaysDateLabel;
- (IBAction)doneButton:(UIButton *)sender;
- (IBAction)playAudio:(UIButton *)sender;
- (IBAction)slide:(UISlider *)sender;
- (IBAction)showFullPicture:(UIButton *)sender;

@end