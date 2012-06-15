//
//  Notes.h
//  scales
//
//  Created by andrew morton on 6/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notes : NSObject
+ (NSInteger)seimtoneFromNote:(NSString*)note;
+ (NSString*)noteFromSemitone:(NSInteger)note;
+ (NSInteger)randomSemitone;
+ (NSString*)randomNote;
@end
