//
//  SetupViewController.m
//  scales
//
//  Created by andrew morton on 6/20/12.
//  Copyright (c) 2012 drewish.com. All rights reserved.
//

#import "SetupViewController.h"
#import "PlayViewController.h"
#import "Lesson.h"

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
    
    // Setup defaults.
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary *defaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithInt:4], @"octave",
                                 [NSNumber numberWithBool:true], @"isTreble",
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"goPlay"]) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setBool:self.isTreble forKey:@"isTreble"];
        [prefs setInteger:self.octave forKey:@"octave"];
        [prefs synchronize];

        Lesson *lesson = [Lesson new];
        lesson.showTreble = self.isTreble;
        lesson.octave = self.octave;
        lesson.notes = [NSMutableArray arrayWithCapacity:12];

        // C major scale
        int majorScale[8] = { 0, 2, 4, 5, 7, 9, 11, 12};
        for (int i = 0; i < 8; i++) {
            [lesson.notes addObject:[Note noteFromMidiNumber:majorScale[i] + ((self.octave + 1) * 12)]];
        }

        // Chromatic scale
//        for (int i = 0; i < 13; i++) {
//            [lesson.notes addObject:[Note noteFromMidiNumber:i + ((self.octave + 1) * 12)]];
//        }

        // Just C in the current octave.
//        [lesson.notes addObject:[Note noteFromMidiNumber:0 + ((self.octave + 1) * 12)]];

        [lesson pickNote];

        PlayViewController *vc = segue.destinationViewController;
        vc.lesson = lesson;
    }
}

# pragma mark All this stuff is too tangled up:

- (IBAction)clefChanged:(UISegmentedControl *)sender {
    // Make sure the octave is reasonable.
    if (self.isTreble && self.octave < 3) {
        self.octave = 3;
    }
    else if (!self.isTreble && self.octave > 4) {
        self.octave = 4;
    }
}

- (IBAction)octaveChanged:(UISegmentedControl *)sender {
    // Make sure low stuff end up in the bass clef...
    if (self.octave < 3) {
        self.isTreble = false;
    }
    // ...and high stuff in the treble.
    else if (self.octave > 4) {
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
