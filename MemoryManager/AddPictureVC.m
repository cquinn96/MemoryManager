//
//  AddPictureVC.m
//  MemoryManager
//
//  Created by Cormac Quinn on 12/08/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddPictureVC.h"

@interface AddPictureVC ()

@end

@implementation AddPictureVC
@synthesize photoLibraryButton;
@synthesize cameraButton;
@synthesize imageView ;
@synthesize overlayVC, capturedImage, pictureFilePath, detailItem, areWeEditing, pictureSwitch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    pictureSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    
    self.overlayVC = [[OverlayVC alloc] initWithNibName:@"OverlayVC" bundle:nil];
    
    // as a delegate we will be notified when pictures are taken and when to dismiss the image picker
    self.overlayVC.delegate = self;
    
    pictureFilePath = [[self.detailItem valueForKey:@"reminderPicture"] description];
    BOOL pictureFileExists = [[NSFileManager defaultManager] fileExistsAtPath:pictureFilePath];
    
    if (pictureFileExists) {
        [pictureSwitch setOn:YES animated:NO];
        areWeEditing=YES;
        NSData *imageData = [[NSData alloc] initWithContentsOfFile:pictureFilePath];
        UIImage *image = [UIImage imageWithData: imageData];
        imageView.image = image;
    }
    else {
        photoLibraryButton.hidden=YES;
        cameraButton.hidden=YES;
        [pictureSwitch setOn:NO animated:NO];
        areWeEditing=NO;
    }
    
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            // camera is not on this device, don't show the camera button
//            NSMutableArray *toolbarItems = [NSMutableArray arrayWithCapacity:self.myToolbar.items.count];
//            [toolbarItems addObjectsFromArray:self.myToolbar.items];
//            [toolbarItems removeObjectAtIndex:2];
//            [self.myToolbar setItems:toolbarItems animated:NO];
            [cameraButton removeFromSuperview];
        }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setPictureSwitch:nil];
    [self setImageView:nil];
    self.overlayVC = nil;
    //self.capturedImages = nil;
    [self setPhotoLibraryButton:nil];
    [self setCameraButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Toolbar Actions

- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    if (capturedImage) {
        capturedImage = nil;
    }
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        [self.overlayVC setupImagePicker:sourceType];
        [self presentModalViewController:self.overlayVC.imagePickerController animated:YES];
    }
}

- (IBAction)pictureSwitchChanged{
    if ([pictureSwitch isOn]) {
        photoLibraryButton.hidden=NO;
        cameraButton.hidden=NO;
    }
    else {
        photoLibraryButton.hidden=YES;
        cameraButton.hidden=YES;
        imageView.image=nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error = nil;
        BOOL pictureFileExists = [fileManager fileExistsAtPath:pictureFilePath];
        if (pictureFileExists) {
            BOOL success = [fileManager removeItemAtPath:pictureFilePath error:&error];
            if (!success) NSLog(@"Error: %@", [error localizedDescription]);
        }
    }
}

- (IBAction)photoLibraryAction:(id)sender {
    [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (IBAction)cameraAction:(id)sender {
    [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
}

#pragma mark OverlayViewControllerDelegate

// as a delegate we are being told a picture was taken
- (void)didTakePicture:(UIImage *)picture
{
    capturedImage = picture;
}

// as a delegate we are told to finished with the camera
- (void)didFinishWithCamera
{
    [self dismissModalViewControllerAnimated:YES];
    
    [self.imageView setImage:capturedImage];
    
    if(capturedImage == nil)
    {
        //        UIActionSheet *confirmCancel = [[UIActionSheet alloc] initWithTitle:@"No Picture" 
        //                                                                    delegate:self 
        //                                                          cancelButtonTitle:@"Cancel" 
        //                                                     destructiveButtonTitle:@"Choose Later" 
        //                                                          otherButtonTitles: nil];
        //        
        //        [confirmCancel showInView:[UIApplication sharedApplication].keyWindow];
    }
    else
    {   
        //delete old image
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error = nil;
        BOOL pictureFileExists = [fileManager fileExistsAtPath:pictureFilePath];
        if (pictureFileExists) {
            BOOL success = [fileManager removeItemAtPath:pictureFilePath error:&error];
            if (!success) NSLog(@"Error: %@", [error localizedDescription]);
        }
        
        //saving the newly selected image
        double seconds = [[NSDate date] timeIntervalSince1970];
        NSString *imageName = [NSString stringWithFormat:@"%f.jpeg", seconds];
        NSData *imageData = UIImageJPEGRepresentation(capturedImage, 1.0);
        NSArray *pathsArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *directoryPath = [pathsArray objectAtIndex:0];
        
        pictureFilePath = [directoryPath stringByAppendingPathComponent:imageName];
        
        [imageData writeToFile:pictureFilePath atomically:YES];
        
        //        if ([imageData writeToFile:filePath atomically:YES]) 
        //        { 
        //            
        //            [self.navigationController popViewControllerAnimated:YES];
        //        } 
        //        else 
        //        {
        //            UIAlertView *errorOccured = [[UIAlertView alloc] initWithTitle:@"Error Occured" 
        //                                                                   message:@"There's been a problem adding a piture Try again?" 
        //                                                                  delegate:self 
        //                                                         cancelButtonTitle:@"OK" 
        //                                                         otherButtonTitles: nil];
        //            [errorOccured show];
        //            [self.navigationController popViewControllerAnimated:YES];
        //        }
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SwitchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
    }
    cell.textLabel.text = @"Picture";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryView = pictureSwitch;
    [pictureSwitch addTarget:self action:@selector(pictureSwitchChanged) forControlEvents:UIControlEventValueChanged];
    
    [cell setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1]];
    
    return cell;
}

@end