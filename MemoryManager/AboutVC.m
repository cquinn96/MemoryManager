//
//  AboutVC.m
//  MemoryManager
//
//  Created by Cormac Quinn on 05/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AboutVC.h"
#import "QuartzCore/QuartzCore.h"

@interface AboutVC ()

@end

@implementation AboutVC
@synthesize aboutLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    aboutLabel.layer.borderColor = [UIColor blackColor].CGColor;
    aboutLabel.layer.borderWidth = 2.0;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setAboutLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
