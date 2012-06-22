//
//  ScaleNoteView.h
//  scales
//
//  Created by andrew morton on 6/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lesson.h"

@interface ScaleNoteView : UIView
@property Lesson *lesson;
@property NSInteger octaveOffset;

@end
