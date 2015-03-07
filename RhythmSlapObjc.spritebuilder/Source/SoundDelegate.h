//
//  SoundDelegate.h
//  RhythmSlapObjc
//
//  Created by Brian Wang on 3/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"
#import <AudioToolbox/AudioToolbox.h>

@interface SoundDelegate : CCNode
@property (strong, nonatomic) AVAudioPlayer *lowBeatAudioPlayer;
@property (strong, nonatomic) AVAudioPlayer *medBeatAudioPlayer;
@property (strong, nonatomic) AVAudioPlayer *highBeatAudioPlayer;
@property (strong, nonatomic) AVAudioPlayer *leftAudioPlayer;
@property (strong, nonatomic) AVAudioPlayer *rightAudioPlayer;
@property (strong, nonatomic) AVAudioPlayer *upAudioPlayer;
@property (strong, nonatomic) AVAudioPlayer *downAudioPlayer;

@property (strong, nonatomic) NSURL *lowBeat;
@property (strong, nonatomic) NSURL *medBeat;
@property (strong, nonatomic) NSURL *highBeat;
@property (strong, nonatomic) NSURL *leftBeat;
@property (strong, nonatomic) NSURL *rightBeat;
@property (strong, nonatomic) NSURL *upBeat;
@property (strong, nonatomic) NSURL *downBeat;

@property (strong, nonatomic) NSMutableArray *listOfAudioPlayers;

-(id) init;
-(void) playLow;
-(void) playMed;
-(void) playHigh;
-(void) playLeft;
-(void) playRight;
-(void) playUp;
-(void) playDown;
@end
