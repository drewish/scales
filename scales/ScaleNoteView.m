//
//  ScaleNoteView.m
//  scales
//
//  Created by andrew morton on 6/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScaleNoteView.h"

@implementation ScaleNoteView

// This should probably end up in a model.
@synthesize note;
@synthesize octave;

NSInteger spacing = 15;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        self.note = @"c";
        self.octave = [NSNumber numberWithInt:4];
    }
    return self;
}

// TODO: I'm not using this yet but I started on it thinking I'd convert stuff 
// to semi tones.
- (NSInteger)seimtoneFromNote:(NSString*)n
{
    if ([n isEqualToString:@"c"])
        return 0;
    else if ([n isEqualToString:@"c♯"] || [n isEqualToString:@"d♭"])
        return 1;
    else if ([n isEqualToString:@"d"])
        return 2;
    else if ([n isEqualToString:@"d♯"] || [n isEqualToString:@"e♭"])
        return 3;
    else if ([n isEqualToString:@"e"])
        return 4;
    else if ([n isEqualToString:@"f"])
        return 5;
    else if ([n isEqualToString:@"f♯"] || [n isEqualToString:@"g♭"])
        return 6;
    else if ([n isEqualToString:@"g"])
        return 7;
    else if ([n isEqualToString:@"g♯"] || [n isEqualToString:@"a♭"])
        return 8;
    else if ([n isEqualToString:@"a"])
        return 9;
    else if ([n isEqualToString:@"a♯"] || [n isEqualToString:@"b♭"])
        return 10;
    else if ([n isEqualToString:@"b"])
        return 11;
    else
        return -1;
}

- (CGFloat)spotOfLine:(NSInteger) i
{
    return i + 2;
}

// Spots are our sort of custom coordinate that are done in terms of spaces
// between lines on the staff. They start at the top line of the staff and count
// down the page. Half a spot will put you in the space between them.
// TODO: probably need to come up with a sane starting point to count these and
// flip the direction so they count up. maybe we put c0 at the 0 spot
- (CGFloat)yOfSpot:(CGFloat)i
{
    return (i * spacing) + (spacing * 2);
}

// Gives a spot back for a note at an octave.
// Octave should be between 1-6 but we only really handle 4-6 at this point.
// TODO: the lower stuff is crazy out of bounds. we should just switch the
//   clef for the low ones
// TODO: redo this and yOfSpot to be saner in terms of starting points.
- (CGFloat)spotOfNote:(NSString*)n octave:(NSInteger)o
{
    // The 6 is there because C6 lines up to the top of our view currently. So
    // we move down to find C in the octave...
    CGFloat spot = (6 - o) * 3.5 + 1;
    // ...then move it upwards for a specific note.
    NSString *letter = [n substringToIndex:1];
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

- (void)drawStaff
{
    // Draw the lines in the staff.
    UIBezierPath *staff = [UIBezierPath bezierPath];
    staff.lineWidth = 2;
    CGFloat w = [self frame].size.width;
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
}

// TODO: maybe we should pass in the width of the note?
- (void)drawLegerLinesToSpot:(CGFloat)spot atX:(CGFloat)x
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

// Draw a note at a given x coordinate. The note can have an accidental.
- (void)drawNote:(NSString*)n octave:(NSInteger) o atX:(CGFloat) x
{
    CGFloat spot = [self spotOfNote:n octave:o];
    CGSize size = CGSizeMake(22, 15);
    CGPoint center = CGPointMake(x, [self yOfSpot:spot]);
    CGRect outterBounds = CGRectMake(center.x - (size.width / 2), center.y - (size.height / 2), size.width, size.height);
    CGFloat innerSize = size.height * .8;
    CGRect innerBounds = CGRectMake(center.x - (innerSize / 2), center.y - (innerSize / 2), innerSize, innerSize);
    UIBezierPath *wholeNote = [UIBezierPath bezierPathWithOvalInRect: outterBounds];
    [wholeNote appendPath: [UIBezierPath bezierPathWithOvalInRect: innerBounds]];
    wholeNote.usesEvenOddFillRule = YES;
    [wholeNote fill];
    
    if (n.length == 2) {
        NSString *accidental = [n substringWithRange:NSMakeRange(1, 1)];
        UIFont *font = [UIFont fontWithName:@"CourierNewPS-BoldMT" size:36];
        CGSize textSize = [accidental sizeWithFont:font];
        CGPoint textPoint = center;
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
    
    // TODO: if we're above or below the staff add leger lines.
    if (spot < 1 || spot > 5) {
        [self drawLegerLinesToSpot:spot atX:x];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self drawStaff];

    NSLog(@"%@%@", note, octave);
    [self drawNote:note octave:[octave integerValue] atX:100];

//    [self drawNote:@"b♭" octave:4 atX:150];
//    [self drawNote:@"a♯" octave:4 atX:200];
}

@end
