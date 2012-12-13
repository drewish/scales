//
//  BaseLayer.m
//  scales
//
//  Created by andrew morton on 12/12/12.
//
//

#import "BaseLayer.h"
#import "Note.h"

@implementation BaseLayer

- (CGFloat)yOfLine:(NSInteger) i
{
    // The spacing is points between lines.
    NSInteger spacing = 15;
    return ((i + 2) * spacing) + (spacing * 2);
}

- (CGFloat)yOfNote:(Note*)note
{
    NSInteger middle = self.frame.size.height / 2;
    // We'll make the middle C4 and put the G cleff above it and E cleff blow.
    return note.midiNumber;
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
    // Two blank lines at the top.
    return (2 + i) * spacing;
}

- (CGFloat)spotOfLine:(NSInteger) i
{
    return i + 2;
}

// Gives a spot back for a note.
// TODO: redo this and yOfSpot to be saner in terms of starting points.
- (CGFloat)spotOfNote:(Note*)n
{
    CGFloat spot = 0;

    // Use C4 as the starting point between the two staffs, subtrack it out of
    // the octave then multiply by the spaces...
    spot = [self spotOfLine:6] + ((4 - n.octave) * 3.5);

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


- (void)drawAccidental:(NSString*)accidental centeredAt:(CGPoint)center
{
    UIFont *font = [UIFont fontWithName:@"CourierNewPS-BoldMT" size:36];
    CGSize textSize = [accidental sizeWithFont:font];
    CGPoint textPoint = center;
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


// TODO: maybe we should pass in the width of the note?
- (void)drawLedgerLinesToSpot:(CGFloat)spot atX:(CGFloat)x
{
    NSInteger top = [self spotOfLine:1],
    bottom = [self spotOfLine:11],
    begin,
    end;

    // Between the staffs is a special case.
    if (spot == 8) {
        begin = end = 8;
    }
    else if (spot < top) {
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
    line.lineWidth = 1;
    for (NSInteger i = begin; i <= end; i++) {
        CGFloat y = [self yOfSpot:i];
        [line moveToPoint:CGPointMake(x - 15, y)];
        [line addLineToPoint:CGPointMake(x + 15, y)];
    }
    [line stroke];
}

@end
