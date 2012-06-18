//
//  Lesson.h
//  scales
//
//  Created by andrew morton on 6/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"

@interface Lesson : NSObject
@property(readonly) Note *currentNote;
@property NSMutableDictionary *notes;
@property CGFloat progress;

//+ (NSInteger)randomSemitone;
- (void)pickRandomNote;
- (BOOL)matchesGuess:(Note*)guess;

@end
