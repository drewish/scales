//
//  Note.m
//  scales
//
//  Created by andrew morton on 6/17/12.
//  Copyright (c) 2012 drewish.com. All rights reserved.
//

#import "Note.h"

@implementation Note
//@synthesize letter;
//@synthesize accidental;
//@synthesize octave;
@synthesize direction;
@synthesize midiNumber;

+ (id)noteFromMidiNumber:(NSInteger)i
{
    return [[self alloc] initWithMidiNumber:i];
}

+ (id)noteFromString:(NSString*)s inOctave:(NSInteger)o
{
    return [[self alloc] initWithString:s inOctave:o];
}

- (id)initWithMidiNumber:(NSInteger)i
{
    self = [super init];
    NSAssert(i >= 0 && i < 127, @"MIDI Number is out of range.");
    midiNumber = i;
    direction = NoteUp;
    return self;
}

// It might be better to just do this as a regex...
- (id)initWithString:(NSString*)s inOctave:(NSInteger)o
{
    self = [super init];

    // Put the pipes in to hold the spaces so the index matches the MIDI note
    // offset.
    NSString *notes = @"c|d|ef|g|a|b";
    NSCharacterSet *letters = [NSCharacterSet characterSetWithCharactersInString:@"abcdefg"];
    NSCharacterSet *digits = [NSCharacterSet decimalDigitCharacterSet];
    NSString *letter;
    // This is bad that we're duplicating the parameter in the string.
    NSInteger octave = o;

    midiNumber = 0;
    direction = NoteDown;

    // Let's just deal with lowercase for simplicity.
    s = [s lowercaseString];

    if (s.length == 1) {
        letter = s;
    }
    else if (s.length > 1) {
        letter = [s substringToIndex:1];
        NSString *suffix = [s substringWithRange:NSMakeRange(1, 1)];
        // If there's an accidental add that to the MIDI number and then factor
        // that into the default formatting.
        if ([suffix isEqualToString:@"♯"] || [suffix isEqualToString:@"#"]) {
            midiNumber += 1;
            direction = NoteUp;
        }
        else if ([suffix isEqualToString:@"♭"] || [suffix isEqualToString:@"b"]) {
            midiNumber -= 1;
            direction = NoteDown;
        }

        // Check the second character for an octave...
        else if ([digits characterIsMember:[suffix characterAtIndex:0]]) {
            octave = [suffix integerValue];
        }
        // And if there wasn't any thing there, check the 3rd.
        if (s.length > 2 && [digits characterIsMember:[s characterAtIndex:2]]) {
            octave = [[s substringWithRange:NSMakeRange(2, 1)] integerValue];
        }
    }

    // Figure out what the note adds...
    assert([letters characterIsMember:[s characterAtIndex:0]]);
    NSRange r = [notes rangeOfString:letter];
    midiNumber += r.location;

    // ...then put in the octave.
    assert(NSLocationInRange(octave, NSMakeRange(1, 6)));
    midiNumber += (octave + 1) * 12;

    return self;
}

// Ignore octaves for equality purposes.
- (BOOL)isEqualToNote:(id)obj
{
    if ([obj isKindOfClass:[Note class]]) {
        Note *other = (Note *)obj;
        return (self.semitone == other.semitone);
    }
    return NO;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"%@%@%i", self.letter, self.accidental, self.octave];
}

- (NSInteger)midiNote
{
    return midiNumber;
}

- (NSString*) letter
{
    // There's probably a more elegant way to do this… but this gets it done.
    NSString *notes;
    if (self.direction == NoteUp) {
        notes = @"ccddeffggaab";
    }
    if (self.direction == NoteDown) {
        notes = @"cddeefggaabb";
    }
    NSString *letter = [notes substringWithRange:NSMakeRange(midiNumber % 12, 1)];
    return letter;
}

- (NSString*) accidental
{
    NSInteger index = midiNumber % 12;
    if (index == 1 || index == 3 || index == 6 || index == 8 || index == 10) {
        if (self.direction == NoteUp) {
            return @"♯";
        }
        return @"♭";
    }
    return @"";
}

- (NSInteger)octave
{
    return (midiNumber / 12) - 1;
}

- (NSInteger)semitone
{
    return midiNumber % 12;
}
@end
