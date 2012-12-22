//
//  Lesson.m
//  scales
//
//  Created by andrew morton on 6/17/12.
//  Copyright (c) 2012 drewish.com. All rights reserved.
//

#include <stdlib.h>
#import "Lesson.h"

const NSInteger GOOD = 0;
const NSInteger BAD = 6;

@implementation Lesson {
    NSMutableArray *notes;
    NSInteger currentIndex;
    NSInteger maxIndex;
    NSInteger overallErrorRate;
}
@synthesize octave;
@synthesize showTreble;
@synthesize delegate;

- (id)init
{
    self = [super init];
    // Put some default stuff in.
    [self setNotes:@[[Note noteFromString:@"c" inOctave:4]]];
    return self;
}

- (NSArray*) notes {
    return notes;
}

- (void)setNotes: (NSArray*) newNotes
{
    notes = [NSMutableArray array];
    for (Note *n in newNotes) {
        [notes addObject:[@{@"note": n, @"errorRate": @(BAD)} mutableCopy]];
    }
    currentIndex = 0;
    overallErrorRate = BAD;
    maxIndex = MIN([notes count], 2);
}

- (void)adjustErrorRate:(NSInteger)value
{
    NSDictionary *current = [notes objectAtIndex:currentIndex];
    value = [[current objectForKey:@"errorRate"] integerValue] + value;
    [[notes objectAtIndex:currentIndex] setValue:@(value) forKey:@"errorRate"];
}

- (Note*) currentNote
{
    return [[notes objectAtIndex:currentIndex] objectForKey:@"note"];
}

- (void)pickRandomNote
{
    Note *next;
    int random;
    // Pull out a random key to use as the next note.
    do {
        random = arc4random_uniform(maxIndex);
    }
    // Make sure we don't keep picking the same note.
    while (maxIndex > 1 && random == currentIndex);
    currentIndex = random;
    next = [notes objectAtIndex:currentIndex];
    // TODO should probably look at setting the note direction based on the
    // previous note, flip it for now.
    next.direction = (next.direction == NoteDown) ? NoteUp : NoteDown;
}

- (void)pickNextNote
{
    if (maxIndex == 1) {
        currentIndex = 0;
    }
    else {
        currentIndex = (currentIndex + 1) % (maxIndex);
    }
    
    // TODO should probably look at setting the note direction based on the
    // previous note
}

// Inspired by http://c2.com/ward/morse/morse.html
-(void)pickWeightedNote
{
    // Figure out the total of the weights...
    NSArray *working = [notes subarrayWithRange:NSMakeRange(0, maxIndex)];
    NSInteger sum = [[working valueForKeyPath:@"@sum.errorRate"] integerValue];
    // ...then a random number in there...
    sum = arc4random_uniform(sum);
    // ...step through and and subtract each weight until we get to zero and
    // then stop and use that note.
    NSInteger i = 0;
    for (NSDictionary *item in notes) {
        sum -= [[item objectForKey:@"errorRate"] integerValue];
        if (sum < 0) {
            break;
        }
        i++;
    }
    currentIndex = i;
}

- (void)pickNote
{
    [self pickWeightedNote];

    [delegate noteChanged];
}

- (void)grade:(Note*)guess
{
    if ([[self currentNote] isEqualToNote:guess]) {
        // Update the weights.
        overallErrorRate = (overallErrorRate + GOOD) / 2;
        [self adjustErrorRate:-1];

        // If they're ready and we have more notes then add one.
        if (overallErrorRate < 1 && maxIndex < notes.count) {
            // TODO if we introduce a new note it should always be picked next.
            maxIndex++;
            // Dumb it down a little bit so they don't get overwhelemed
            overallErrorRate = (overallErrorRate + 2 * BAD) / 2;
        }

        [self.delegate guessedRight];
        [self pickNote];
    }
    else {
        // Update the weights.
        overallErrorRate = (overallErrorRate + BAD) / 2;
        [self adjustErrorRate:1];

        // Let them try again.
        [self.delegate guessedWrong];
    }

    NSLog(@"graded... working set:\n%@\noverall: %i", [notes subarrayWithRange:NSMakeRange(0, maxIndex)], overallErrorRate);
}

- (void)timedOut
{
    // Update the weight.
    overallErrorRate = (overallErrorRate + BAD) / 2;
    [self adjustErrorRate:1];

    // Let them try again.
    [self.delegate timedOut];
}

@end
