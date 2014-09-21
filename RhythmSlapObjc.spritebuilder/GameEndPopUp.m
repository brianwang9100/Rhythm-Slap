//
//  GameEndPopUp.m
//  RhythmSlapObjc
//
//  Created by Brian Wang on 9/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameEndPopUp.h"

@implementation GameEndPopUp
{
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
    id fadeIn = [CCActionFadeTo actionWithDuration:1.5 opacity:1];
    [_gameOverColor runAction:fadeIn];
    
    _gameOverText.position = ccp(0.5, -1);
    id gameOverDropDown = [CCActionMoveTo actionWithDuration:2 position:ccp(.5, .1)];
    id gameOverElasticDown = [CCActionEaseElasticInOut actionWithAction:gameOverDropDown period:.4];
    [_gameOverText runAction:gameOverElasticDown];
    
    _yourScoreTitle.position = ccp(0.5, -1);
    id yourScoreDropDown = [CCActionMoveTo actionWithDuration:3 position:ccp(.5, .328)];
    id yourScoreElasticDown = [CCActionEaseElasticInOut actionWithAction:yourScoreDropDown period:.4];
    [_yourScoreTitle runAction:yourScoreElasticDown];
    
    _yourScoreNum.position = ccp(-1, .398);
    id scoreNumDropDown = [CCActionMoveTo actionWithDuration:5 position:ccp(.5, .398)];
    id scoreNumElasticDown = [CCActionEaseElasticInOut actionWithAction:scoreNumDropDown period:.4];
    [_yourScoreNum runAction:scoreNumElasticDown];
    
    _highScoreTitle.position = ccp(0.5, -1);
    id highScoreDropDown = [CCActionMoveTo actionWithDuration:3 position:ccp(.5, .528)];
    id highScoreElasticDown = [CCActionEaseElasticInOut actionWithAction:highScoreDropDown period:.4];
    [_highScoreTitle runAction:highScoreElasticDown];
    
    _highScoreNum.position = ccp(-1, .598);
    id highNumDropDown = [CCActionMoveTo actionWithDuration:5 position:ccp(.5, .598)];
    id highNumElasticDown = [CCActionEaseElasticInOut actionWithAction:highNumDropDown period:.4];
    [_highScoreNum runAction:highNumElasticDown];
    
    _tryAgain.position = ccp(0.5, -1);
    id tryAgainDropDown = [CCActionMoveTo actionWithDuration:4 position:ccp(.5, .232)];
    id tryAgainElasticDown = [CCActionEaseElasticInOut actionWithAction:tryAgainDropDown period:.4];
    [_tryAgain runAction:tryAgainElasticDown];
    
    _mainMenu.position = ccp(0.5, -1);
    id mainMenuDropDown = [CCActionMoveTo actionWithDuration:4 position:ccp(.5, .125)];
    id mainMenuElasticDown = [CCActionEaseElasticInOut actionWithAction:mainMenuDropDown period:.4];
    [_mainMenu runAction:mainMenuElasticDown];
    
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

-(void) retry
{
    [_lowBeatAudioPlayer play];
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene: mainScene];
}

-(void) mainMenu
{
    [_highBeatAudioPlayer play];
    CCScene *startScene = [CCBReader loadAsScene:@"StartScene"];
    [[CCDirector sharedDirector] replaceScene: startScene];
}
@end
