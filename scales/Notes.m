//
//  Notes.m
//  scales
//
//  Created by andrew morton on 6/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Notes.h"

@implementation Notes

// TODO: I'm not using this yet but I started on it thinking I'd convert stuff 
// to semi tones.
+ (NSInteger)seimtoneFromNote:(NSString*)n
{
    if ([n isEqualToString:@"c"])
        return 0;
    else if ([n isEqualToString:@"c♯"] || [n isEqualToString:@"d♭"])
        return 1;
    else if ([n isEqualToString:@"d"])
        return 2;
    else if ([n isEqualToString:@"d♯"] || [n isEqualToString:@"e♭"])
        return 3;
    else if ([n isEqualToString:@"e"])
        return 4;
    else if ([n isEqualToString:@"f"])
        return 5;
    else if ([n isEqualToString:@"f♯"] || [n isEqualToString:@"g♭"])
        return 6;
    else if ([n isEqualToString:@"g"])
        return 7;
    else if ([n isEqualToString:@"g♯"] || [n isEqualToString:@"a♭"])
        return 8;
    else if ([n isEqualToString:@"a"])
        return 9;
    else if ([n isEqualToString:@"a♯"] || [n isEqualToString:@"b♭"])
        return 10;
    else if ([n isEqualToString:@"b"])
        return 11;
    else
        return -1;
}

+ (NSString*)noteFromSemitone:(NSInteger)n
{
    switch (n) {
        case 0: return @"c";
        case 1: return @"c♯";
        case 2: return @"d";
        case 3: return @"d♯";
        case 4: return @"e";
        case 5: return @"f";
        case 6: return @"f♯";
        case 7: return @"g";
        case 8: return @"g♯";
        case 9: return @"a";
        case 10: return @"a♯";
        case 11: return @"b";
    }
    return nil;
}

+ (NSInteger)randomSemitone
{
    return arc4random_uniform(11);
}

+ (NSString*)randomNote
{
    return [self noteFromSemitone: [self randomSemitone]];
}

@end
