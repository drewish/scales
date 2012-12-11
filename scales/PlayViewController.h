//
//  ViewController.h
//  scales
//
//  Created by andrew morton on 6/15/12.
//  Copyright (c) 2012 drewish.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lesson.h"

@class NotePlayer;

@interface PlayViewController : UIViewController<LessonDelegate>
@property (weak, nonatomic) IBOutlet UILabel *streakLabel;
@property(readonly) CALayer *staffLayer;
@property(readonly) CALayer *noteLayer;
@property NotePlayer *player;
@property Lesson *lesson;
@property NSInteger streak;
- (IBAction)pressed:(id)sender;
- (IBAction)pressNote:(id)sender;
- (IBAction)releaseNote:(id)sender;
- (void)noteStart:(Note*)note;
- (void)noteStop:(Note*)note;
@end
