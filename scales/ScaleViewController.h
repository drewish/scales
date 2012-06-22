//
//  ScaleViewController.h
//  scales
//
//  Created by andrew morton on 6/22/12.
//  Copyright (c) 2012 drewish.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lesson.h"

@interface ScaleViewController : UITableViewController
@property Lesson *lesson;
@property NSString* scale;
@end
