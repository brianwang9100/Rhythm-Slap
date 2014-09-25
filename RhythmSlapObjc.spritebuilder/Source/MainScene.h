//
//  MainScene.h
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "CCScene.h"
#import "Hand.h"
#import "Face.h"
#import "ComboBar.h"
#import "GameEndPopUp.h"
#import "Timer.h"
#import "SlapGestures.h"


@interface MainScene : CCScene
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
@end
