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


// The audio processing graph should not run when the screen is locked or when the app has
//  transitioned to the background, because there can be no user interaction in those states.
//  (Leaving the graph running with the screen locked wastes a significant amount of energy.)
//
// Responding to these UIApplication notifications allows this class to stop and restart the
//    graph as appropriate.
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

    staffLayer = [CALayer layer];
    staffLayer.frame = frame;
//    staffLayer.borderColor = [[UIColor orangeColor] CGColor];
//    staffLayer.borderWidth = 1;
    staffLayer.contentsScale = [[UIScreen mainScreen] scale];
    staffLayer.delegate = self;
    [self.view.layer addSublayer:staffLayer];
    [staffLayer setNeedsDisplay];

    noteLayer = [CALayer layer];
    noteLayer.frame = CGRectMake(staffLayer.frame.size.width - staffLayer.frame.origin.x,
                                 staffLayer.frame.origin.y,
                                 45,
                                 staffLayer.frame.size.height);
//    noteLayer.borderColor = [[UIColor greenColor] CGColor];
//    noteLayer.borderWidth = 1;
    noteLayer.contentsScale = [[UIScreen mainScreen] scale];
    noteLayer.delegate = self;
    [self.view.layer addSublayer:noteLayer];
    [noteLayer setNeedsDisplay];


//    for (int i = 1; i < 13; i ++) {
//        CALayer *key = [[self.view viewWithTag:i] layer];
//        key.borderWidth = 1;
//        if (i == 2 || i == 4 || i == 7 || i == 9 || i == 11) {
//            key.borderColor = [[UIColor whiteColor] CGColor];
//        }
//    }
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
        spot = (6 - n.octave) * 3.5 + 1;
    }
    else {
        // Bass cleff C4 is ??? lines above the first line.
        spot = (4 - n.octave) * 3.5 + 2;
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
    // Make some minor adjustments to put the character in the right position.
    if ([accidental isEqualToString:@"♯"]) {
        textPoint.x -= textSize.width + 10;
        textPoint.y -= textSize.height / 2.1;
    }
    else if ([accidental isEqualToString:@"♭"]) {
        textPoint.x -= textSize.width + 5;
        textPoint.y -= textSize.height / 1.75;
    }
    else if ([accidental isEqualToString:@"♮"]) {
        // Not going to worry about ♮ yet.
    }
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
        noteLayer.frame = CGRectMake(staffLayer.frame.size.width - staffLayer.frame.origin.x,
                                     staffLayer.frame.origin.y,
                                     45,
                                     staffLayer.frame.size.height);
        [self drawNote:lesson.currentNote atX:30];
    }
    UIGraphicsPopContext();
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
    [noteLayer setNeedsDisplay];

    Note *n = lesson.currentNote;
    [self noteStart:n];
    [self performSelector:@selector(noteStop:) withObject:n afterDelay:0.2];
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
