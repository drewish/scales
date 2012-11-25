//
//  Lesson.m
//  scales
//
//  Created by andrew morton on 6/17/12.
//  Copyright (c) 2012 drewish.com. All rights reserved.
//

#include <stdlib.h>
#import "Lesson.h"

@implementation Lesson
@synthesize currentNote;
@synthesize notes;
@synthesize octave;
@synthesize showTreble;
@synthesize progress;
@synthesize delta;
@synthesize delegate;

//
//+ (NSInteger)randomSemitone
//{
//    return arc4random_uniform(12);
//}
//
//+ (NSString*)randomNote
//{
//    return [self noteFromSemitone: [self randomSemitone]];
//}

- (id)init
{
    self = [super init];
    progress = 0.0;
    delta = 5;
    currentNote = [Note noteFromString:@"c"];
    notes = [NSMutableArray new];
    return self;
}

- (void)pickRandomNote
{
    // Pull out a random key to use as the next note.
    int random = arc4random_uniform(notes.count);
    currentNote = [notes objectAtIndex:random];
}

- (void)guess:(Note*)guess
{
    if ([currentNote isEqual:guess]) {
        [self guessedRight];
    }
    else {
        [self guessedWrong];
    }
}

- (void)guessedRight
{
    // Start again with a new piece.
    progress = 0.0;
    [self pickRandomNote];
    // Spead it up a little bit.
    //delta += 0.5;
    [self.delegate guessedRight];
}

- (void)guessedWrong
{
    progress = -0.1;

    // Make it a little easier.
    if (delta > 5) {
        delta = 2;
    }
    else if (delta > 2) {
        delta *= 0.5;
    }
    // Make sure we don't stop.
    if (delta <= 0) {
        delta = 1;
    }
    [self.delegate guessedWrong];
}

- (void)timedOut
{
    progress = -0.1;
    [self.delegate timedOut];
}

-(void)tick
{
    progress += (delta / 100);
    if (progress >= 1.0) {
        [self timedOut];
    }
}
@end
