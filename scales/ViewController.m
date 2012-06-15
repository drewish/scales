//
//  ViewController.m
//  scales
//
//  Created by andrew morton on 6/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "Notes.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize scaleView;
@synthesize streakLabel;
NSTimer *timer;
NSInteger startX;
NSInteger endX;
NSInteger streak;
CGFloat delta;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    startX = 300;
    endX = 75;
    delta = 5;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                     target:self
                                   selector:@selector(tick:)
                                   userInfo:nil
                                    repeats:YES];
    scaleView.x = startX;
    scaleView.note = [Notes randomNote];
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
    NSString *choice = [[s titleForSegmentAtIndex:s.selectedSegmentIndex] lowercaseString];
    if ([choice isEqualToString:scaleView.note]) {
        // Start again with a new piece.
        scaleView.note = [Notes randomNote];
        [self guessRight:self];
    }
    else {
        [self guessWrong:self];
    }
}

- (IBAction)octaveChange:(id)sender {
    UIStepper *s = (UIStepper *)sender;
    scaleView.octave = [s value];
    
    [scaleView setNeedsDisplay];
}

- (IBAction)guessWrong:(id)sender {
    // Make them do it again and get it right.
    scaleView.x = startX;
    streak = 0;
    streakLabel.text = [NSString stringWithFormat:@"%i", streak];
    // Make it a little easier.
    if (delta > 2) {
        delta *= 0.5;        
    }
    // Make sure we don't stop.
    if (delta < 1) {
        delta = 1;
    }
    streakLabel.text = [NSString stringWithFormat:@"delta: %f", delta];

    [scaleView setNeedsDisplay];
}

- (IBAction)guessRight:(id)sender {
    scaleView.x = startX;
    // Keep score
    streak += 1;
    streakLabel.text = [NSString stringWithFormat:@"%i", streak];
    // Spead it up a little bit.
    delta += 1;
    
    [scaleView setNeedsDisplay];
}

- (void) tick:(NSTimer*)theTimer
{
    if (scaleView.x <= endX) {
        [self guessWrong:self];
    }
    else {
        scaleView.x -= delta;        
    }
    [scaleView setNeedsDisplay];
}

@end
