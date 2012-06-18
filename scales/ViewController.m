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
NSTimer *timer;
NSInteger streak;
CGFloat delta;
Lesson *lesson;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    delta = 5;
    
    lesson = [Lesson new];
    lesson.notes = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                    // C Blues scale.
                    [Note noteFromLetter:@"c" inOctave:4], @"C",
                    [Note noteFromLetter:@"e" accidental:@"b" inOctave:4], @"E♭",
                    [Note noteFromLetter:@"f" inOctave:4], @"F",
                    [Note noteFromString:@"gb4"], @"G♭",
                    [Note noteFromLetter:@"b" accidental:@"♭" inOctave:4], @"B♭",
                    [Note noteFromLetter:@"C" inOctave:5], @"C",
                    nil];
    lesson.progress = 0.0;
    //lesson.currentNote = @"c4";
    [lesson pickRandomNote];
    
    scaleView.showTreble = true;
    scaleView.octaveOffset = 0;
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
    if ([lesson matchesGuess:choice]) {
        // Start again with a new piece.
        [lesson pickRandomNote];
        [self guessRight:self];
    }
    else {
        [self guessWrong:self];
    }
}

- (IBAction)octaveChange:(id)sender {
    UIStepper *s = (UIStepper *)sender;
    scaleView.octaveOffset = [s value];
    
    [scaleView setNeedsDisplay];
}

- (IBAction)guessWrong:(id)sender {
    // Give them a break then make them do it right.
    lesson.progress = -0.1;
    streak = 0;
    streakLabel.text = [NSString stringWithFormat:@"%i", streak];
    // Make it a little easier.
    if (delta > 5) {
        delta = 2;
    } 
    else if (delta > 2) {
        delta *= 0.5;        
    }
    // Make sure we don't stop.
    if (delta <= 0) {
        delta = 1;
    }
    streakLabel.text = [NSString stringWithFormat:@"delta: %f", delta];

    [scaleView setNeedsDisplay];
}

- (IBAction)guessRight:(id)sender {
    lesson.progress = 0.0;
    // Keep score
    streak += 1;
    streakLabel.text = [NSString stringWithFormat:@"%i", streak];
    // Spead it up a little bit.
    delta += 0.5;
    
    [scaleView setNeedsDisplay];
}

- (void) tick:(NSTimer*)theTimer
{
    if (lesson.progress >= 1.0) {
        [self guessWrong:self];
    }
    else {
        lesson.progress += (delta / 100);        
    }
    [scaleView setNeedsDisplay];
}

@end
