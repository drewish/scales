//
//  ViewController.h
//  scales
//
//  Created by andrew morton on 6/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScaleNoteView.h"

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet ScaleNoteView *scaleView;
@property (weak, nonatomic) IBOutlet UILabel *streakLabel;
- (IBAction)pressed:(id)sender;
- (IBAction)octaveChange:(id)sender;
- (IBAction)guessWrong:(id)sender;
- (IBAction)guessRight:(id)sender;

@end
