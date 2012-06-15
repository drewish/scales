//
//  ScaleNoteView.m
//  scales
//
//  Created by andrew morton on 6/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScaleNoteView.h"

@implementation ScaleNoteView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{    
    // Draw the lines in the staff.
    UIBezierPath *staff = [UIBezierPath bezierPath];
    staff.lineWidth = 2;
    CGFloat separation = 15, offset = 15;
    CGFloat w = [self frame].size.width;
    for (int i = 1; i < 6; ++i) {
        [staff moveToPoint:CGPointMake(0, i * separation + offset)];
        [staff addLineToPoint:CGPointMake(w, i * separation + offset)];
    }
    [staff stroke];
    
    
    // Put the note on the staff.
    int octave = 5; // say 1-6, 6 is the very top of our view and will get cut off.
    char letter = 'e';

    CGPoint center = CGPointMake(120, (6-octave) * (separation * 3.5));
    if (letter == 'd') {
        center.y -= separation * .5;
    } else if (letter == 'e') {
        center.y -= separation * 1;
    } else if (letter == 'f') {
        center.y -= separation * 1.5;
    } else if (letter == 'g') {
        center.y -= separation * 2;
    } else if (letter == 'a') {
        center.y -= separation * 2.5;
    } else if (letter == 'b') {
        center.y -= separation * 3;
    }
    
    CGSize size = CGSizeMake(30, 20);
    CGRect outterBounds = CGRectMake(center.x - (size.width / 2), center.y - (size.height / 2), size.width, size.height);
    CGFloat innerSize = size.height * .8;
    CGRect innerBounds = CGRectMake(center.x - (innerSize / 2), center.y - (innerSize / 2), innerSize, innerSize);
    UIBezierPath *note = [UIBezierPath bezierPathWithOvalInRect: outterBounds];
    [note appendPath: [UIBezierPath bezierPathWithOvalInRect: innerBounds]];
    note.usesEvenOddFillRule = YES;
    [note fill];
    
    // TODO: if we're above or below the staff add leger lines.
}

@end
