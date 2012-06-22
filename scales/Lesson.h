//
//  Lesson.h
//  scales
//
//  Created by andrew morton on 6/17/12.
//  Copyright (c) 2012 drewish.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"

@protocol LessonDelegate
- (void)guessedRight;
- (void)guessedWrong;
- (void)timedOut;
@end

@interface Lesson : NSObject
@property(readonly) Note *currentNote;
@property NSInteger octave;
@property NSMutableDictionary *notes;
@property CGFloat progress;
@property CGFloat delta;
@property bool showTreble;
@property id<LessonDelegate> delegate;

//+ (NSInteger)randomSemitone;
- (void)pickRandomNote;
- (BOOL)matchesGuess:(Note*)guess;
- (void)tick;
- (void)guess:(Note*)guess;
- (void)guessedRight;
- (void)guessedWrong;
- (void)timedOut;

@end
