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
- (void)noteChanged;
- (void)guessedRight;
- (void)guessedWrong;
- (void)timedOut;
@end

@interface Lesson : NSObject
@property(readonly) Note *currentNote;
@property NSInteger octave;
@property NSArray *notes;
@property bool showTreble;
@property id<LessonDelegate> delegate;

//+ (NSInteger)randomSemitone;
- (void)pickNote;
- (void)grade:(Note*)guess;
- (void)timedOut;

@end
