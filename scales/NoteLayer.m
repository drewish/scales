//
//  NoteLayer.m
//  scales
//
//  Created by andrew morton on 12/11/12.
//
//

#import "NoteLayer.h"
#import "Note.h"

@implementation NoteLayer

@synthesize note;


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
        [self drawAccidental:n.accidental centeredAt:CGPointMake(x, center.y)];
    }

    [self drawLedgerLinesToSpot:spot atX:x];
}

-(void) drawInContext:(CGContextRef)ctx
{
    UIGraphicsPushContext(ctx);
    CGRect superFrame = self.superlayer.frame;
    self.frame = CGRectMake(superFrame.size.width - 45,
               0,
               45,
               superFrame.size.height);
    [self drawNote:self.note atX:30];

    UIGraphicsPopContext();
}

@end
