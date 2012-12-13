//
//  Note.h
//  scales
//
//  Created by andrew morton on 6/17/12.
//  Copyright (c) 2012 drewish.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum  {
    NoteUp,
    NoteDown
} NoteDirection;

@interface Note : NSObject

+ (id)noteFromMidiNumber:(NSInteger)i;
// Valid examples @"c", @"e#", @"gb", @"b♭", @"C"
+ (id)noteFromString:(NSString*)s inOctave:(NSInteger)o;

- (id)initWithMidiNumber:(NSInteger)i;
- (id)initWithString:(NSString*)s inOctave:(NSInteger)o;

- (BOOL)isEqualToNote:(id)obj;

@property(readonly) NSInteger midiNumber;
@property(readonly) NSInteger octave;
@property(readonly) NSInteger semitone;
@property(readonly) NSString* letter;
@property(readonly) NSString* accidental;
@property NoteDirection direction;

@end
