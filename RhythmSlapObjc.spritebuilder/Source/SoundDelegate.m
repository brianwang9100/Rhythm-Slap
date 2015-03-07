//
//  SoundDelegate.m
//  RhythmSlapObjc
//
//  Created by Brian Wang on 3/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "SoundDelegate.h"

@implementation SoundDelegate
{
    
}

-(id) init
{
    _lowBeat = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"beat_bfxr" ofType:@"wav"]];
    _medBeat = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"beat_high" ofType:@"wav"]];
    _highBeat = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"beat_higher" ofType:@"wav"]];
    _leftBeat = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"left_bfxr" ofType:@"wav"]];
    _rightBeat = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"right_bfxr" ofType:@"wav"]];
    _upBeat = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"uppercut_bfxr" ofType:@"wav"]];
    _downBeat = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"headbash_bfxr" ofType:@"wav"]];
    
    _lowBeatAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:_lowBeat error:nil];
    _medBeatAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:_medBeat error:nil];
    _highBeatAudioPlayer= [[AVAudioPlayer alloc] initWithContentsOfURL:_highBeat error:nil];
    _leftAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:_leftBeat error:nil];
    _rightAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:_rightBeat error:nil];
    _upAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:_upBeat error:nil];
    _downAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:_downBeat error:nil];
    
    self.listOfAudioPlayers = [NSMutableArray arrayWithObjects: self.lowBeatAudioPlayer, self.medBeatAudioPlayer, self.highBeatAudioPlayer, self.leftAudioPlayer, self.rightAudioPlayer, self.upAudioPlayer, self.downAudioPlayer, nil];
    
    return self;
}

-(void) playLow
{
    if ([_lowBeatAudioPlayer isPlaying])
    {
        [_lowBeatAudioPlayer stop];
    }
    [_lowBeatAudioPlayer prepareToPlay];
    [_lowBeatAudioPlayer play];
}

-(void) playMed
{
    if ([_medBeatAudioPlayer isPlaying])
    {
        [_medBeatAudioPlayer stop];
    }
    [_medBeatAudioPlayer prepareToPlay];
    [_medBeatAudioPlayer play];
}

-(void) playHigh
{
    if ([_highBeatAudioPlayer isPlaying])
    {
        [_highBeatAudioPlayer stop];
    }
    [_highBeatAudioPlayer prepareToPlay];
    [_highBeatAudioPlayer play];
}

-(void) playLeft
{
    if ([_leftAudioPlayer isPlaying])
    {
        [_leftAudioPlayer stop];
    }
    [_leftAudioPlayer prepareToPlay];
    [_leftAudioPlayer play];
}

-(void) playRight
{
    if ([_rightAudioPlayer isPlaying])
    {
        [_rightAudioPlayer stop];
    }
    [_rightAudioPlayer prepareToPlay];
    [_rightAudioPlayer play];
}

-(void) playUp
{
    if ([_upAudioPlayer isPlaying])
    {
        [_upAudioPlayer stop];
    }
    [_upAudioPlayer prepareToPlay];
    [_upAudioPlayer play];
}

-(void) playDown
{
    if ([_downAudioPlayer isPlaying])
    {
        [_downAudioPlayer stop];
    }
    [_downAudioPlayer prepareToPlay];
    [_downAudioPlayer play];
}


@end
