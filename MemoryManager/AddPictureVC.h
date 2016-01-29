//
//  AddPictureVC.h
//  MemoryManager
//
//  Created by Cormac Quinn on 12/08/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverlayVC.h"
#import "Reminder.h"

@interface AddPictureVC : UIViewController <UIImagePickerControllerDelegate, OverlayVCDelegate>{
    OverlayVC *overlayVC;
    BOOL areWeEditing;
}

@property BOOL areWeEditing;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) OverlayVC *overlayVC;
@property (weak, nonatomic) IBOutlet UIButton *photoLibraryButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (nonatomic, retain) UIImage *capturedImage;
@property (nonatomic, retain) NSString *pictureFilePath;
@property (nonatomic, retain) Reminder *detailItem;
@property (nonatomic, retain) UISwitch *pictureSwitch;

- (IBAction)pictureSwitchChanged:(UISwitch *)sender;
- (IBAction)photoLibraryAction:(id)sender;
- (IBAction)cameraAction:(id)sender;

@end
