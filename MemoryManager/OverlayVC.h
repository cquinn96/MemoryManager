//
//  OverlayVC.h
//  MemoryManager
//
//  Created by Cormac Quinn on 14/08/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OverlayVCDelegate;

@interface OverlayVC : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    id <OverlayVCDelegate> delegate;
}

@property (nonatomic, retain) UIImagePickerController *imagePickerController;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *takePictureButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *cancelButton;
@property (nonatomic, retain) id <OverlayVCDelegate> delegate;

- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType;

- (IBAction)done:(id)sender;
- (IBAction)takePhoto:(id)sender;

@end

@protocol OverlayVCDelegate
- (void)didTakePicture:(UIImage *)picture;
- (void)didFinishWithCamera;
@end
