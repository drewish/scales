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

- (NSString *)description
{
    NSMutableString *s = [NSMutableString stringWithFormat:@"\nOverall:|%@|\n", [@"" stringByPaddingToLength:overallErrorRate withString: @"-+" startingAtIndex:0]];
    NSInteger i = 0;
    for (NSDictionary *item in notes) {
        if (i <= maxIndex) {
            NSString *bar = [@"" stringByPaddingToLength:[[item objectForKey:@"errorRate"] integerValue] withString: @"-+" startingAtIndex:0];
            if (i == currentIndex) {
                [s appendFormat:@">%@<", [item objectForKey:@"note"]];
            }
            else {
                [s appendFormat:@" %@ ", [item objectForKey:@"note"]];
            }
            [s appendFormat:@"\t|%@|\n", bar];

        }
        else {
            [s appendFormat:@" %@\n", [item objectForKey:@"note"]];
        }

        i++;
    }
    return s;
}


- (NSArray*) notes {
    return notes;
}

- (void)setNotes: (NSArray*) newNotes
{
    NSAssert([newNotes count] > 0, @"New notes don't have enough items.");
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
    // Make sure we're in a realistic range.
    value = MAX(1, MIN(BAD, value));
    [[notes objectAtIndex:currentIndex] setValue:@(value) forKey:@"errorRate"];

    NSInteger i = 0;
    NSInteger sum = 0;
    // Figure out the total of the error rates of the active notes...
    for (i = 0; i <= maxIndex; i++) {
        sum += [[[notes objectAtIndex:i] objectForKey:@"errorRate"] integerValue];
    }
    overallErrorRate = sum / (maxIndex + 1);
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
    NSInteger i = 0;
    NSInteger sum = 0;
    // Figure out the total of the error rates of the active notes...
    for (i = 0; i <= maxIndex; i++) {
        sum += [[[notes objectAtIndex:i] objectForKey:@"errorRate"] integerValue];
    }
    // ...then a random number in there...
    sum = arc4random_uniform(sum + 1);
    // ...step through and and subtract each weight until we get to zero and
    // then stop and use that note.
    i = 0;
    for (NSDictionary *item in notes) {
        sum -= [[item objectForKey:@"errorRate"] integerValue];
        if (sum <= 0) {
            break;
        }
        i++;
    }
    currentIndex = i;
}

- (void)pickNote
{
    [self pickWeightedNote];

    NSLog(@"%@", [self description]);

    [delegate noteChanged];
}

- (void)grade:(Note*)guess
{
    if ([[self currentNote] isEqualToNote:guess]) {
        // Update the weights.
        [self adjustErrorRate:-1];

        // If they're ready and we have more notes then add one.
        if (overallErrorRate < 2 && maxIndex < (notes.count - 1)) {
            // TODO if we introduce a new note it should always be picked next.
            maxIndex++;
            // Dumb it down a little bit so they don't get overwhelemed
            overallErrorRate = BAD;
        }

        [self.delegate guessedRight];
        [self pickNote];
    }
    else {
        // Update the weights.
        [self adjustErrorRate:2];
        // TODO: we should look at grading them down on the note they guessed
        // since they had them mixed up.

        // Let them try again.
        [self.delegate guessedWrong];
    }
}

- (void)timedOut
{
    // Update the weight.
    [self adjustErrorRate:1];

    // Let them try again.
    [self.delegate timedOut];
}

@end
