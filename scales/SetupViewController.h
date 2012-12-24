//
//  SetupViewController.h
//  scales
//
//  Created by andrew morton on 6/20/12.
//  Copyright (c) 2012 drewish.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetupViewController : UITableViewController
@property NSInteger octave;
@property BOOL isTreble;
@property (weak, nonatomic) IBOutlet UISegmentedControl *octaveControl;
- (IBAction)octaveChanged:(UISegmentedControl *)sender;

@end
