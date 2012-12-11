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
@synthesize activeNotes;
@synthesize octave;
@synthesize showTreble;
@synthesize delegate;

- (id)init
{
    self = [super init];
    // Put some default stuff in.
    currentNote = [Note noteFromString:@"c" inOctave:4];
    notes = [@[currentNote] mutableCopy];
    return self;
}

- (void)pickRandomNote
{
    Note *next;
    // Pull out a random key to use as the next note.
    do {
        int random = arc4random_uniform(notes.count);
        next = [notes objectAtIndex:random];
    }
    // Make sure we don't keep picking the same note.
    while (notes.count > 1 && [next isEqual:currentNote]);
    // TODO should probably look at setting the note direction based on the
    // previous note, flip it for now.
    next.direction = (next.direction == NoteDown) ? NoteUp : NoteDown;
    currentNote = next;

    [delegate noteChanged];
}

- (void)pickNextNote
{
    int index = ([notes indexOfObject:currentNote] + 1) % (notes.count - 1);
    Note *next = [notes objectAtIndex:index];
    // TODO should probably look at setting the note direction based on the
    // previous note
    currentNote = next;

    [delegate noteChanged];
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
    [self pickRandomNote];
//    [self pickNextNote];
    [self.delegate guessedRight];
}

- (void)guessedWrong
{
    // Let them try again.
    [self.delegate guessedWrong];
}

- (void)timedOut
{
    // Let them try again.
    [self.delegate timedOut];
}

@end
