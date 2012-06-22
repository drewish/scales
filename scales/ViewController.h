//
//  ViewController.h
//  scales
//
//  Created by andrew morton on 6/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScaleNoteView.h"

@interface ViewController : UIViewController<LessonDelegate>
@property (weak, nonatomic) IBOutlet ScaleNoteView *scaleView;
@property (weak, nonatomic) IBOutlet UILabel *streakLabel;
@property Lesson *lesson;
@property NSInteger streak;
- (IBAction)pressed:(id)sender;

@end
