//
//  ViewController.h
//  scales
//
//  Created by andrew morton on 6/15/12.
//  Copyright (c) 2012 drewish.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScaleNoteView.h"

@interface PlayViewController : UIViewController<LessonDelegate>
@property (weak, nonatomic) IBOutlet ScaleNoteView *scaleView;
@property (weak, nonatomic) IBOutlet UILabel *streakLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *accidentalsCDE;
@property (weak, nonatomic) IBOutlet UISegmentedControl *accidentalsFGAB;
@property Lesson *lesson;
@property NSInteger streak;
- (IBAction)pressed:(id)sender;

@end
