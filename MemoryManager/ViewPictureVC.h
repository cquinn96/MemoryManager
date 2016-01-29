//
//  ViewPictureVC.h
//  MemoryManager
//
//  Created by Cormac Quinn on 31/08/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewPictureVC : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *fullPictureView;

@property (nonatomic, retain) UIImage *picture;

@end