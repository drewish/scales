//
//  SetupViewController.h
//  scales
//
//  Created by andrew morton on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetupViewController : UITableViewController
@property NSInteger octave;
@property BOOL isTreble;
@property (weak, nonatomic) IBOutlet UISegmentedControl *clefControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *octaveControl;
- (IBAction)clefChanged:(UISegmentedControl *)sender;
- (IBAction)octaveChanged:(UISegmentedControl *)sender;

@end
