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
        self.octave = [NSNumber numberWithInt:3];
    }
    return self;    
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

// TODO: should accept pass in a # or ♭
- (void)drawNoteAtSpot:(CGFloat)spot x:(CGFloat) x
{
    CGSize size = CGSizeMake(22, 15);
    CGPoint center = CGPointMake(x, [self yOfSpot:spot]);
    CGRect outterBounds = CGRectMake(center.x - (size.width / 2), center.y - (size.height / 2), size.width, size.height);
    CGFloat innerSize = size.height * .8;
    CGRect innerBounds = CGRectMake(center.x - (innerSize / 2), center.y - (innerSize / 2), innerSize, innerSize);
    UIBezierPath *wholeNote = [UIBezierPath bezierPathWithOvalInRect: outterBounds];
    [wholeNote appendPath: [UIBezierPath bezierPathWithOvalInRect: innerBounds]];
    wholeNote.usesEvenOddFillRule = YES;
    [wholeNote fill];
    
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
    CGFloat spot = [self spotOfNote:note octave:[octave integerValue]];
    [self drawNoteAtSpot:spot x: 100];

}

@end
