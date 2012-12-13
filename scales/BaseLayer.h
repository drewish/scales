//
//  BaseLayer.h
//  scales
//
//  Created by andrew morton on 12/12/12.
//
//

#import <QuartzCore/QuartzCore.h>

@class Note;

@interface BaseLayer : CALayer

- (CGFloat)spotOfLine:(NSInteger) i;
- (CGFloat)spotOfNote:(Note*) n;

- (CGFloat)yOfLine:(NSInteger) i;
- (CGFloat)yOfNote:(Note*) note;
- (CGFloat)yOfSpot:(CGFloat) i;

- (void)drawAccidental:(NSString*)accidental centeredAt:(CGPoint)center;
- (void)drawLedgerLinesToSpot:(CGFloat)spot atX:(CGFloat)x;

@end
