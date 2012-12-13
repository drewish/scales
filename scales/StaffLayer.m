//
//  StaffLayer.m
//  scales
//
//  Created by andrew morton on 12/10/12.
//
//

#import "StaffLayer.h"
#import "Note.h"

@implementation StaffLayer

-(void) drawInContext:(CGContextRef)ctx
{
    UIGraphicsPushContext(ctx);

    UIImage *img;

    [[UIColor blackColor] setStroke];

    // Draw the lines in the staff.
    UIBezierPath *staff = [UIBezierPath bezierPath];
    staff.lineWidth = 1;
    CGFloat w = self.frame.size.width;
    CGFloat y;

    // TREBLE CLEFF
    // Horizontal lines
    for (int i = 1; i < 6; ++i) {
        y = [self yOfLine:i];
        [staff moveToPoint:CGPointMake(0, y)];
        [staff addLineToPoint:CGPointMake(w, y)];
    }
    // Vertical end line
    [staff moveToPoint:CGPointMake(w - 1, [self yOfLine:1])];
    [staff addLineToPoint:CGPointMake(w - 1, [self yOfLine:5])];

    img = [UIImage imageNamed:@"GClef.png"];
    [img drawInRect:CGRectMake(5, 57, 37, 103)];

    // BASS CLEFF
    // Horizontal lines
    for (int i = 7; i < 12; ++i) {
        y = [self yOfLine:i];
        [staff moveToPoint:CGPointMake(0, y)];
        [staff addLineToPoint:CGPointMake(w, y)];
    }
    // Vertical end line
    [staff moveToPoint:CGPointMake(w - 1, [self yOfLine:7])];
    [staff addLineToPoint:CGPointMake(w - 1, [self yOfLine:11])];

    img = [UIImage imageNamed:@"FClef.png"];
    [img drawInRect:CGRectMake(5, 166, 40, 45)];

    [staff stroke];

    UIGraphicsPopContext();
}

@end
