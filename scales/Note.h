//
//  Note.h
//  scales
//
//  Created by andrew morton on 6/17/12.
//  Copyright (c) 2012 drewish.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Note : NSObject
+ (id)noteFromString:(NSString*)s;
+ (id)noteFromLetter:(NSString*)l inOctave:(NSInteger)o;
+ (id)noteFromLetter:(NSString*)l accidental:(NSString*)a inOctave:(NSInteger)o;

- (id)initWithString:(NSString*)s;
- (id)initWithLetter:(NSString*)l inOctave:(NSInteger)o;
- (id)initWithLetter:(NSString*)l accidental:(NSString*)a inOctave:(NSInteger)o;

@property(readonly) NSString *letter;
@property(readonly) NSString *accidental;
@property(readonly) NSNumber *octave;
@property(readonly) NSInteger semitone;
@end
