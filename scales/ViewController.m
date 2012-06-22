//
//  ViewController.m
//  scales
//
//  Created by andrew morton on 6/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "Lesson.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize scaleView;
@synthesize streakLabel;
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)pressed:(id)sender {
    UISegmentedControl *s = (UISegmentedControl *)sender;
    Note *choice = [Note noteFromString:[s titleForSegmentAtIndex:s.selectedSegmentIndex]];
    [lesson guess:choice];
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
