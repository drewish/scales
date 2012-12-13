//
//  ViewController.m
//  scales
//
//  Created by andrew morton on 6/15/12.
//  Copyright (c) 2012 drewish.com. All rights reserved.
//

#import "PlayViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "NotePlayer.h"
#import "Lesson.h"
#import "StaffLayer.h"
#import "NoteLayer.h"

@interface PlayViewController ()

@end

@implementation PlayViewController {
    NSTimeInterval dt;
}

@synthesize player;
@synthesize staffLayer;
@synthesize noteLayer;
@synthesize streakLabel;
@synthesize lesson;
@synthesize streak;
NSTimer *timer;


// The audio processing graph should not run when the screen is locked or when
// the app has transitioned to the background, because there can be no user
// interaction in those states. (Leaving the graph running with the screen
// locked wastes a significant amount of energy.)
//
// Responding to these UIApplication notifications allows this class to stop and
// restart the graph as appropriate.
- (void) registerForUIApplicationNotifications {

    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

    [notificationCenter addObserver: self
                           selector: @selector (handleResigningActive:)
                               name: UIApplicationWillResignActiveNotification
                             object: [UIApplication sharedApplication]];

    [notificationCenter addObserver: self
                           selector: @selector (handleBecomingActive:)
                               name: UIApplicationDidBecomeActiveNotification
                             object: [UIApplication sharedApplication]];
}


- (void) handleResigningActive: (id) notification {
    [player stopAudioProcessingGraph];
}

- (void) handleBecomingActive: (id) notification {
    [player restartAudioProcessingGraph];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    dt = 1;

    lesson.delegate = self;
    player = [NotePlayer new];
    timer = [NSTimer scheduledTimerWithTimeInterval:dt
                                     target:self
                                   selector:@selector(tick:)
                                   userInfo:nil
                                    repeats:YES];
}

- (void) viewDidAppear:(BOOL)animated
{
    CGRect frame = CGRectInset(self.view.frame, 20, 20);

    staffLayer = [StaffLayer layer];
    staffLayer.frame = frame;
//    staffLayer.borderColor = [[UIColor orangeColor] CGColor];
//    staffLayer.borderWidth = 1;
    staffLayer.contentsScale = [[UIScreen mainScreen] scale];
    [self.view.layer addSublayer:staffLayer];
    [staffLayer setNeedsDisplay];

    noteLayer = [NoteLayer layer];
    noteLayer.note = lesson.currentNote;
    noteLayer.frame = CGRectMake(staffLayer.frame.size.width - 45,
                                 0,
                                 45,
                                 staffLayer.frame.size.height);
//    noteLayer.borderColor = [[UIColor greenColor] CGColor];
//    noteLayer.borderWidth = 1;
    noteLayer.contentsScale = [[UIScreen mainScreen] scale];
    [staffLayer addSublayer:noteLayer];
    [noteLayer setNeedsDisplay];


//    for (int i = 1; i < 13; i ++) {
//        CALayer *key = [[self.view viewWithTag:i] layer];
//        key.borderWidth = 1;
//        if (i == 2 || i == 4 || i == 7 || i == 9 || i == 11) {
//            key.borderColor = [[UIColor whiteColor] CGColor];
//        }
//    }
}


- (void)viewDidUnload
{
    [self setStreakLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)noteStart:(Note*)note {
    [player startNote:note.midiNumber];
}

- (void)noteStop:(Note*)note {
    [player stopNote:note.midiNumber];
}

- (IBAction)pressNote:(id)sender {
    Note *n = [Note noteFromMidiNumber:([sender tag] - 1) + (lesson.octave + 1) * 12];
    [self noteStart:n];
    //    [self performSelector:@selector(noteStop:) withObject:n afterDelay:0.2];
}

- (IBAction)releaseNote:(id)sender {
    Note *n = [Note noteFromMidiNumber:([sender tag] - 1) + (lesson.octave + 1) * 12];
    [self noteStop:n];
}

- (IBAction)pressed:(UISegmentedControl *)sender {
    sender.selected = false;
    [lesson guess:[Note noteFromMidiNumber:(sender.tag - 1)]];
}

- (void)tick:(NSTimer*)theTimer
{
    noteLayer.frame = CGRectOffset(noteLayer.frame, -15, 0);
    // 40 accounts for the width of the cleff.
    if (noteLayer.frame.origin.x < staffLayer.frame.origin.x + 41) {
        [lesson timedOut];
    }
}

- (void)noteChanged
{
    noteLayer.note = lesson.currentNote;
    [noteLayer setNeedsDisplay];
    noteLayer.hidden = false;

    Note *n = lesson.currentNote;
    [self noteStart:n];
    [self performSelector:@selector(noteStop:) withObject:n afterDelay:0.2];
}

- (void)timedOut
{
    noteLayer.hidden = true;
    [self guessedWrong];
}

- (void)guessedRight
{
    // Keep score
    streak += 1;
    streakLabel.text = [NSString stringWithFormat:@"%i", streak];
    noteLayer.hidden = true;
}

- (void)guessedWrong
{
    // Give them a break then make them do it right.
    streak = 0;
    streakLabel.text = [NSString stringWithFormat:@"%i", streak];

    // This isn't great but I want some minimal feed back for now.
    UIView *view = [self.view viewWithTag:(lesson.currentNote.semitone + 1)];
    if ([view isKindOfClass:[UIButton class]]) {
        [(UIButton*)view setSelected:true];
    }
/*
// create the animation that will handle the pulsing.
CABasicAnimation* pulseAnimation = [CABasicAnimation animation];

// the attribute we want to animate is the inputIntensity
// of the pulseFilter
pulseAnimation.keyPath = @"filters.pulseFilter.inputIntensity";

// we want it to animate from the value 0 to 1
pulseAnimation.fromValue = [NSNumber numberWithFloat: 0.0];
pulseAnimation.toValue = [NSNumber numberWithFloat: 1.5];

// over a one second duration, and run an infinite
// number of times
pulseAnimation.duration = 1.0;

// use a timing curve of easy in, easy out..
pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];

// add the animation to the selection layer. This causes
// it to begin animating. We'll use pulseAnimation as the
// animation key name
[selectionLayer addAnimation:pulseAnimation forKey:@"pulseAnimation"];
*/
}

@end
