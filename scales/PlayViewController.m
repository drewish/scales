//
//  ViewController.m
//  scales
//
//  Created by andrew morton on 6/15/12.
//  Copyright (c) 2012 drewish.com. All rights reserved.
//

#import "PlayViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Lesson.h"

@interface PlayViewController ()

@end

@implementation PlayViewController {
    NSTimeInterval dt;
}
@synthesize staffLayer;
@synthesize noteLayer;
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

    dt = 0.2;

    lesson.delegate = self;

    timer = [NSTimer scheduledTimerWithTimeInterval:dt
                                     target:self
                                   selector:@selector(tick:)
                                   userInfo:nil
                                    repeats:YES];
}

- (void) viewDidAppear:(BOOL)animated
{
    CGRect frame = CGRectInset(self.view.frame, 20, 20);

    staffLayer = [CALayer layer];
    [staffLayer setFrame:frame];
    [self.view.layer addSublayer:staffLayer];
    [staffLayer setDelegate:self];
    [staffLayer setNeedsDisplay];

    noteLayer = [CALayer layer];
    [noteLayer setFrame:CGRectMake(staffLayer.frame.size.width, staffLayer.frame.origin.y, 50, staffLayer.frame.size.height)];
    [self.view.layer addSublayer:noteLayer];
    [noteLayer setDelegate:self];
    [noteLayer setNeedsDisplay];
}


// Spots are our sort of custom coordinate that are done in terms of spaces
// between lines on the staff. They start at the top line of the staff and count
// down the page. Half a spot will put you in the space between them.
// TODO: probably need to come up with a sane starting point to count these and
// flip the direction so they count up. maybe we put c0 at the 0 spot
- (CGFloat)yOfSpot:(CGFloat)i
{
    // The spacing is points between lines.
    NSInteger spacing = 15;
    return (i * spacing) + (spacing * 2);
}

// Gives a spot back for a note.
// TODO: redo this and yOfSpot to be saner in terms of starting points.
- (CGFloat)spotOfNote:(Note*)n
{
    CGFloat spot;

    // So we move down to find C in the octave...
    if (lesson.showTreble) {
        // The 6 is there because C6 lines up two ledger lines from the top
        spot = (6 - n.octave.integerValue) * 3.5 + 1;
    }
    else {
        // Bass cleff C4 is ??? lines above the first line.
        spot = (4 - n.octave.integerValue) * 3.5 + 2;
    }
    // ...then move it upwards for a specific note.
    NSString *letter = [n.letter substringToIndex:1];
    if ([letter isEqualToString:@"d"]) {
        spot -= 0.5;
    } else if ([letter isEqualToString:@"e"]) {
        spot -= 1;
    } else if ([letter isEqualToString:@"f"]) {
        spot -= 1.5;
    } else if ([letter isEqualToString:@"g"]) {
        spot -= 2;
    } else if ([letter isEqualToString:@"a"]) {
        spot -= 2.5;
    } else if ([letter isEqualToString:@"b"]) {
        spot -= 3;
    }
    return spot;
}

- (CGFloat)spotOfLine:(NSInteger) i
{
    return i + 2;
}

- (void)drawStaff
{
    // Draw the lines in the staff.
    UIBezierPath *staff = [UIBezierPath bezierPath];
    staff.lineWidth = 2;
    CGFloat w = staffLayer.frame.size.width;
    CGFloat y;
    // Horizontal lines
    for (int i = 1; i < 6; ++i) {
        y = [self yOfSpot:[self spotOfLine:i]];
        [staff moveToPoint:CGPointMake(0, y)];
        [staff addLineToPoint:CGPointMake(w, y)];
    }
    // Vertical end line
    [staff moveToPoint:CGPointMake(w - 1, [self yOfSpot:[self spotOfLine:1]])];
    [staff addLineToPoint:CGPointMake(w - 1, [self yOfSpot:[self spotOfLine:5]])];
    [staff stroke];
    // Put the clef mark on.
    UIImage *img;
    if (lesson.showTreble) {
        img = [UIImage imageNamed:@"GClef.png"];
        [img drawInRect:CGRectMake(5, 57, 37, 103)];
    }
    else {
        img = [UIImage imageNamed:@"FClef.png"];
        [img drawInRect:CGRectMake(5, 76, 40, 45)];
    }
}

// TODO: maybe we should pass in the width of the note?
- (void)drawLedgerLinesToSpot:(CGFloat)spot atX:(CGFloat)x
{
    NSInteger top = [self spotOfLine:1],
    bottom = [self spotOfLine:5],
    begin,
    end;
    if (spot < top) {
        begin = spot;
        end = top - 1;
    }
    else if (spot > bottom) {
        begin = bottom + 1;
        end = spot;
    }
    else {
        return;
    }
    UIBezierPath *line = [UIBezierPath bezierPath];
    line.lineWidth = 2;
    for (NSInteger i = begin; i <= end; i++) {
        CGFloat y = [self yOfSpot:i];
        [line moveToPoint:CGPointMake(x - 15, y)];
        [line addLineToPoint:CGPointMake(x + 15, y)];
    }
    [line stroke];
}

- (void)drawAccidental:(NSString*)accidental atSpot:(CGFloat) spot andX:(CGFloat) x
{
    UIFont *font = [UIFont fontWithName:@"CourierNewPS-BoldMT" size:36];
    CGSize textSize = [accidental sizeWithFont:font];
    CGPoint textPoint = CGPointMake(x, [self yOfSpot:spot]);
    if ([accidental isEqualToString:@"♯"]) {
        textPoint.x -= textSize.width + 10;
        textPoint.y -= textSize.height / 2.1;
    }
    if ([accidental isEqualToString:@"♭"]) {
        textPoint.x -= textSize.width + 5;
        textPoint.y -= textSize.height / 1.75;
    }
    // Not going to worry about ♮ yet.
    [accidental drawAtPoint:textPoint withFont:font];
}

// Draw a note at a given x coordinate. The note can have an accidental.
- (void)drawNote:(Note*)n atX:(CGFloat) x
{
    CGFloat spot = [self spotOfNote:n];
    CGSize size = CGSizeMake(22, 15);
    CGPoint center = CGPointMake(x, [self yOfSpot:spot]);
    CGRect outterBounds = CGRectMake(center.x - (size.width / 2), center.y - (size.height / 2), size.width, size.height);
    CGFloat innerSize = size.height * .8;
    CGRect innerBounds = CGRectMake(center.x - (innerSize / 2), center.y - (innerSize / 2), innerSize, innerSize);
    UIBezierPath *wholeNote = [UIBezierPath bezierPathWithOvalInRect: outterBounds];
    [wholeNote appendPath: [UIBezierPath bezierPathWithOvalInRect: innerBounds]];
    wholeNote.usesEvenOddFillRule = YES;
    [wholeNote fill];
    
    if (n.accidental.length > 0) {
        [self drawAccidental:n.accidental atSpot:spot andX:x];
    }

    [self drawLedgerLinesToSpot:spot atX:x];
}

- (void) drawLayer:(CALayer*) layer inContext:(CGContextRef) ctx
{
    UIGraphicsPushContext(ctx);
    if (layer == staffLayer) {
        [self drawStaff];
    }
    else if (layer == noteLayer) {
        [noteLayer setFrame:CGRectMake(staffLayer.frame.size.width, staffLayer.frame.origin.y, 50, staffLayer.frame.size.height)];

        [self drawNote:lesson.currentNote atX:30];
    }
    UIGraphicsPopContext();
}

- (void)viewDidUnload
{
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
    CGFloat w = staffLayer.frame.size.width;
//    CGFloat x = w - (lesson.progress * (w - 75));
    noteLayer.frame = CGRectOffset(noteLayer.frame, -10, 0);
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

    [noteLayer setNeedsDisplay];
}

- (void)guessedWrong
{
    // Give them a break then make them do it right.
    streak = 0;
    streakLabel.text = [NSString stringWithFormat:@"%i", streak];

    [noteLayer setNeedsDisplay];
}

@end
