//
//  NotePlayer.h
//  scales
//
//  Created by andrew morton on 11/29/12.
//
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface NotePlayer : NSObject <AVAudioSessionDelegate>

- (void) stopAudioProcessingGraph;
- (void) restartAudioProcessingGraph;

- (void) startNote:(NSInteger)note;
- (void) stopNote:(NSInteger)note;

@end
