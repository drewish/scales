//
//  Note.m
//  scales
//
//  Created by andrew morton on 6/17/12.
//  Copyright (c) 2012 drewish.com. All rights reserved.
//

#import "Note.h"

@implementation Note
@synthesize letter;
@synthesize accidental;
@synthesize octave;

+ (id)noteFromMidiNumber:(NSInteger)i
{
    return [[self alloc] initWithMidiNumber:i];
}
+ (id)noteFromString:(NSString*)s 
{
    return [[self alloc] initWithString:s];
}
+ (id)noteFromLetter:(NSString*)l inOctave:(NSInteger)o
{
    return [[self alloc] initWithLetter:l inOctave:o];
}
+ (id)noteFromLetter:(NSString*)l accidental:(NSString*)a inOctave:(NSInteger)o
{
    return [[self alloc] initWithLetter:l accidental:a inOctave:o];
}

- (id)initWithMidiNumber:(NSInteger)i
{
    // There's probably a more elegant way to do this… but this gets it done.
    NSInteger index = i % 12;
    NSArray *letters = @[@"c", @"c", @"d", @"d", @"e", @"f", @"f", @"g", @"g", @"a", @"a", @"b"];
    NSArray *accidentals = @[@"", @"♯", @"", @"♯", @"", @"", @"♯", @"", @"♯", @"", @"♯", @""];
    letter = [letters objectAtIndex:index];
    accidental = [accidentals objectAtIndex:index];
    octave = [NSNumber numberWithInt:(i / 12) - 1];
    return self;
}

- (id)initWithLetter:(NSString*)l inOctave:(NSInteger)o 
{
    return [self initWithLetter:l accidental:@"" inOctave:o];
}

- (id)initWithLetter:(NSString*)l accidental:(NSString*)a inOctave:(NSInteger)o
{
    letter = [[l substringToIndex:1] lowercaseString];
    accidental = @"";
    if (a.length > 0) {
        a = [a substringToIndex:1];
        if ([a isEqualToString:@"♯"] || [a isEqualToString:@"#"]) {
            accidental = @"♯";
        }
        else if ([a isEqualToString:@"♭"] || [a isEqualToString:@"b"]) {
            accidental = @"♭";
        }
    }
    octave = [NSNumber numberWithInteger:o];
    return self;    
}

// It might be better to just do this as a regex...
- (id)initWithString:(NSString*)s
{
    // Let's just deal with lowercase for simplicity.
    NSString *n = [s lowercaseString];
    NSCharacterSet *letters = [NSCharacterSet characterSetWithCharactersInString:@"abcdefg"];
    NSCharacterSet *digits = [NSCharacterSet decimalDigitCharacterSet];

    letter = @"";
    accidental = @"";
    octave = nil;

    if (n.length == 1) {
        letter = n; 
    }
    else if (n.length > 1) {
        letter = [n substringToIndex:1];
        NSString *suffix = [n substringWithRange:NSMakeRange(1, 1)];
        if ([suffix isEqualToString:@"♯"] || [suffix isEqualToString:@"#"]) {
            accidental = @"♯";
        }
        else if ([suffix isEqualToString:@"♭"] || [suffix isEqualToString:@"b"]) {
            accidental = @"♭";
        }
        // Check the second character for an octave...
        else if ([digits characterIsMember:[suffix characterAtIndex:0]]) {
            octave = [NSNumber numberWithInteger:[suffix integerValue]];
        }
        // And if there wasn't any thing there, check the 3rd.
        if (n.length > 2 && [digits characterIsMember:[n characterAtIndex:2]]) {
            octave = [NSNumber numberWithInteger:[[n substringWithRange:NSMakeRange(2, 1)] integerValue]];
        }
    }
    
    assert([letters characterIsMember:[n characterAtIndex:0]]);
    assert(octave == nil || NSLocationInRange([octave integerValue], NSMakeRange(1, 6)));

    return self;
}

// Ignore octaves for equality purposes.
- (BOOL)isEqual:(id)obj;
{
    if ([obj isKindOfClass:[Note class]]) {
        Note *other = (Note *)obj;
        return (self.semitone == other.semitone);
    }
    return NO;
}

- (NSInteger)midiNote
{
    return ([self.octave integerValue] * 12) + self.semitone;
}


- (NSInteger)semitone
{
    NSInteger i = 0;

    if ([accidental isEqualToString:@"♯"]) {
        i += 1;
    }
    if ([accidental isEqualToString:@"♭"]) {
        i -= 1;
    }
    
    if ([letter isEqualToString:@"c"])
        return i + 0;
    if ([letter isEqualToString:@"d"])
        return i + 2;
    if ([letter isEqualToString:@"e"])
        return i + 4;
    if ([letter isEqualToString:@"f"])
        return i + 5;
    if ([letter isEqualToString:@"g"])
        return i + 7;
    if ([letter isEqualToString:@"a"])
        return i + 9;
    if ([letter isEqualToString:@"b"])
        return i + 11;
    else
        return -1;
}
@end
