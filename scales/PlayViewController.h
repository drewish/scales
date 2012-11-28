//
//  ViewController.h
//  scales
//
//  Created by andrew morton on 6/15/12.
//  Copyright (c) 2012 drewish.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lesson.h"

@interface PlayViewController : UIViewController<LessonDelegate>
@property (weak, nonatomic) IBOutlet UILabel *streakLabel;
@property(readonly) CALayer *staffLayer;
@property(readonly) CALayer *noteLayer;
@property Lesson *lesson;
@property NSInteger streak;
- (IBAction)pressed:(id)sender;

@end
