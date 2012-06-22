//
//  ViewController.m
//  scales
//
//  Created by andrew morton on 6/15/12.
//  Copyright (c) 2012 drewish.com. All rights reserved.
//

#import "PlayViewController.h"
#import "Lesson.h"

@interface PlayViewController ()

@end

@implementation PlayViewController
@synthesize scaleView;
@synthesize streakLabel;
@synthesize accidentalsCDE;
@synthesize accidentalsFGAB;
@synthesize lesson;
@synthesize streak;
NSTimer *timer;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    lesson.delegate = self;
    scaleView.lesson = lesson;

    timer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                     target:self
                                   selector:@selector(tick:)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)viewDidUnload
{
    [self setScaleView:nil];
    [self setStreakLabel:nil];
    [self setAccidentalsCDE:nil];
    [self setAccidentalsFGAB:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)pressed:(UISegmentedControl *)sender {
    NSString *string;
    NSInteger index = sender.selectedSegmentIndex;
    if ([sender isEqual:accidentalsCDE]) {
        if (index == 0) string = @"C#";
        else if (index == 1) string = @"D#";
        else if (index == 2) string = @"E#";
    }
    else if ([sender isEqual:accidentalsFGAB]) {
        if (index == 0) string = @"F#";
        else if (index == 1) string = @"G#";
        else if (index == 2) string = @"A#";
        else if (index == 3) string = @"B#";
    }
    else {
        string = [sender titleForSegmentAtIndex:index];
    }
    [lesson guess:[Note noteFromString:string]];
}

- (void)tick:(NSTimer*)theTimer
{
    [lesson tick];
    [scaleView setNeedsDisplay];
}

- (void)timedOut
{
    [self guessedWrong];
}

- (void)guessedRight
{
    // Keep score
    streak += 1;
    streakLabel.text = [NSString stringWithFormat:@"%i", streak];

    [scaleView setNeedsDisplay];
}

- (void)guessedWrong
{
    // Give them a break then make them do it right.
    streak = 0;
    streakLabel.text = [NSString stringWithFormat:@"%i", streak];

    [scaleView setNeedsDisplay];
}

@end
