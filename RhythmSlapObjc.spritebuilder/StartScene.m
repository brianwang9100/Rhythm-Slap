//
//  StartScene.m
//  RhythmSlapObjc
//
//  Created by Brian Wang on 9/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "StartScene.h"

@implementation StartScene
{
    Face *_face;
    CCNodeGradient *_colorGradientNode;
    CCNodeColor *_glowNode;
    CCNodeColor *_topBar;
    CCNodeColor *_bottomBar;
    CCNodeColor *_test;
    
    UISwipeGestureRecognizer *_swipeLeft;
    UISwipeGestureRecognizer *_swipeRight;
    UISwipeGestureRecognizer *_swipeUp;
    UISwipeGestureRecognizer *_swipeDown;
    
    AVAudioPlayer *_lowBeatAudioPlayer;
    AVAudioPlayer *_medBeatAudioPlayer;
    AVAudioPlayer *_highBeatAudioPlayer;
    AVAudioPlayer *_leftAudioPlayer;
    AVAudioPlayer *_rightAudioPlayer;
    AVAudioPlayer *_upAudioPlayer;
    AVAudioPlayer *_downAudioPlayer;
    
    NSURL *_lowBeat;
    NSURL *_medBeat;
    NSURL *_highBeat;
    NSURL *_leftBeat;
    NSURL *_rightBeat;
    NSURL *_upBeat;
    NSURL *_downBeat;

}

-(void) didLoadFromCCB
{
    _topBar.position = ccp(0, -200);
    id topBarDropDown = [CCActionMoveTo actionWithDuration:1 position:ccp(0, 0)];
    id topBarElasticDown = [CCActionEaseElasticInOut actionWithAction:topBarDropDown period:.4];
    [_topBar runAction:topBarElasticDown];
    
    _bottomBar.position = ccp(0, -200);
    id botBarDropDown = [CCActionMoveTo actionWithDuration:1.25 position:ccp(0, 0)];
    id botBarElasticDown = [CCActionEaseElasticInOut actionWithAction:botBarDropDown period:.4];
    [_bottomBar runAction:botBarElasticDown];
    
    _face.position = ccp(-200, 0);
    id faceSlide = [CCActionMoveTo actionWithDuration:1.5 position:ccp(0.5, 0.5)];
    id faceElasticSlide = [CCActionEaseElasticInOut actionWithAction:faceSlide period:.4];
    [_face runAction:faceElasticSlide];
    
    // listen for swipes to the left
    _swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft)];
    _swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:_swipeLeft];
    // listen for swipes to the right
    _swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight)];
    _swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:_swipeRight];
    // listen for swipes to the top
    _swipeUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUp)];
    _swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:_swipeUp];
    //listen for swipes to the bottom
    _swipeDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDown)];
    _swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:_swipeDown];
    
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

}

-(void) swipeLeft
{
    [_face hitLeft];
    [_leftAudioPlayer play];
    [self removeBars];
    [self performSelector:@selector(startGame) withObject:nil afterDelay:2];
    
}

-(void) swipeRight
{
    //animate face
    [_face hitRight];
    [_rightAudioPlayer play];
    [self removeBars];
    [self performSelector:@selector(startGame) withObject:nil afterDelay:2];
}

-(void) swipeUp
{
    //animate face
    [_face hitUp];
    [_upAudioPlayer play];
    [self removeBars];
    [self performSelector:@selector(startGame) withObject:nil afterDelay:2];
}

-(void) swipeDown
{
    //animate face
    [_face hitDown];
    [_downAudioPlayer play];
    [self removeBars];
    [self performSelector:@selector(startGame) withObject:nil afterDelay:2];
}
-(void) removeBars
{
    id topBarUp = [CCActionMoveTo actionWithDuration:1 position:ccp(0, -200)];
    id topBarElasticUp = [CCActionEaseElasticInOut actionWithAction:topBarUp period:.4];
    [_topBar runAction:topBarElasticUp];
    
    id botBarUp = [CCActionMoveTo actionWithDuration:1.25 position:ccp(0, -200)];
    id botBarElasticUp = [CCActionEaseElasticInOut actionWithAction:botBarUp period:.4];
    [_bottomBar runAction:botBarElasticUp];
    
    id fadeIn = [CCActionFadeTo actionWithDuration:1.5 opacity:1];
    [_test runAction:fadeIn];
    
}
-(void) startGame
{
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene: mainScene];
}
@end
