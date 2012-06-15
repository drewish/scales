//
//  ViewController.m
//  scales
//
//  Created by andrew morton on 6/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize scaleView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setScaleView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)pressed:(id)sender {
    UISegmentedControl *s = (UISegmentedControl *)sender;
    scaleView.note = [[s titleForSegmentAtIndex:s.selectedSegmentIndex] lowercaseString];
    [scaleView setNeedsDisplay];
}

- (IBAction)octaveChange:(id)sender {
    UIStepper *s = (UIStepper *)sender;
    scaleView.octave = [NSNumber numberWithDouble: [s value]];
    [scaleView setNeedsDisplay];
}
@end
