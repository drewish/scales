//
//  SetupViewController.m
//  scales
//
//  Created by andrew morton on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SetupViewController.h"

@interface SetupViewController ()

@end

@implementation SetupViewController
@synthesize octaveControl;
@synthesize clefControl;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // Setup defaults.
    NSDictionary *defaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithInt:4], @"octave",
//                                 true, @"isTreble",
                                 nil];
    [prefs registerDefaults:defaults];
    
    self.isTreble = [prefs boolForKey:@"isTreble"];
    self.octave = [prefs integerForKey:@"octave"];
}

- (void)viewDidUnload
{
    [self setClefControl:nil];
    [self setOctaveControl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

# pragma mark All this stuff is too tangled up:

- (IBAction)clefChanged:(UISegmentedControl *)sender {
    if (self.isTreble && self.octave < 3) {
        self.octave = 3;
    }
    else if (!self.isTreble && self.octave > 4) {
        self.octave = 4;
    }
    [[NSUserDefaults standardUserDefaults] setBool:self.isTreble forKey:@"isTreble"];
    NSLog(sender.selectedSegmentIndex == 0 ? @"Treble" : @"Bass");
}

- (IBAction)octaveChanged:(UISegmentedControl *)sender {
    unsigned short octave = octaveControl.selectedSegmentIndex + 1;
    [[NSUserDefaults standardUserDefaults] setInteger:octave forKey:@"octave"];

    // Make sure low stuff end up in the bass clef...
    if (octave < 3) {
        self.isTreble = false;
    }
    // ...and high stuff in the treble.
    else if (octave > 4) {
        self.isTreble = true;
    }
}

- (NSInteger)octave 
{
    return octaveControl.selectedSegmentIndex + 1;
}

- (void)setOctave:(NSInteger)octave
{
    octaveControl.selectedSegmentIndex = octave - 1;
    [octaveControl sendActionsForControlEvents:UIControlEventValueChanged];
}

- (BOOL)isTreble
{
    return clefControl.selectedSegmentIndex == 1;
}

- (void)setIsTreble:(BOOL)isTreble
{
    clefControl.selectedSegmentIndex = (isTreble ? 1 : 0);
    [clefControl sendActionsForControlEvents:UIControlEventValueChanged];
}
@end
