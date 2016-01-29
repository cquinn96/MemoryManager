//
//  ViewPictureVC.m
//  MemoryManager
//
//  Created by Cormac Quinn on 31/08/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewPictureVC.h"

@interface ViewPictureVC ()

@end

@implementation ViewPictureVC
@synthesize fullPictureView, picture;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)done{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    fullPictureView.image = picture;
}

- (void)viewDidUnload
{
    [self setFullPictureView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
