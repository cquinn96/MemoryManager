//
//  GuideTableVC.h
//  MemoryManager
//
//  Created by Cormac Quinn on 20/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuideTableVC : UITableViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *myLabel;


@end