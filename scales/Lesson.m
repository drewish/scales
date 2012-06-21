//
//  Lesson.m
//  scales
//
//  Created by andrew morton on 6/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include <stdlib.h>
#import "Lesson.h"

@implementation Lesson
@synthesize currentNote;
@synthesize notes;
@synthesize progress;

//
//+ (NSInteger)randomSemitone
//{
//    return arc4random_uniform(12);
//}
//
//+ (NSString*)randomNote
//{
//    return [self noteFromSemitone: [self randomSemitone]];
//}

- (id)init
{
    self = [super init];
    progress = 0.0;
    currentNote = [Note noteFromString:@"c"];
    notes = [NSMutableDictionary new];
    return self;
}

- (void)pickRandomNote
{
    // Pull out a random key to use as the next note.
    NSString *key = [[notes allKeys] objectAtIndex:arc4random_uniform(notes.count - 1)];
    currentNote = [notes objectForKey:key];
}

- (BOOL)matchesGuess:(Note*)guess
{
    return [currentNote isEqual:guess];
}
                      
@end
