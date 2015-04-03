//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import <AudioToolbox/AudioToolbox.h>
@import AVFoundation;
#define ARC4RANDOM_MAX 0x100000000

@implementation MainScene
{
    Hand *_hand;
    Face *_face;
    Timer *_timer;
    ComboBar *_comboBar;
    CCNodeGradient *_colorGradientNode;
    CCNodeColor *_glowNode;
    CCNodeColor *_whiteNode;
    CCLabelTTF *_gestureMessageTop;
    CCLabelTTF *_gestureMessageBot;
    CCLabelTTF *_comboModeLabel;
    NSUserDefaults *_defaults;

    double _currentNumOfBeats;
    int _waveNumOfBeats;
   
    int _pointMultiplier;
    int _totalScore;
    
    CCLabelTTF *_totalScoreLabel;
    CCLabelTTF *_tutorialLabel;

    BOOL _gameCountdownMode;
    int _gameCountdown;

    BOOL _gameStarted;
    BOOL _gameEnded;
    BOOL _tutorialMode;
    BOOL _comboMode;

    NSArray *_fourSlap;
    NSArray *_threeSlapOneDouble;
    NSArray *_twoDoubleOneTriple;
    NSArray *_twoSlapOneDown;

    NSMutableArray *_queue;
    NSMutableArray *_queueForTutorial;

    int _comboBarSize;

    NSArray *_currentGestureSet;
    int _currentGestureSetIndex;
    SlapGestures *_currentGesture;
    int _totalPoints;

    UISwipeGestureRecognizer *_swipeLeft;
    UISwipeGestureRecognizer *_swipeRight;
    UISwipeGestureRecognizer *_swipeUp;
    UISwipeGestureRecognizer *_swipeDown;
    
    double _gestureTimeStamp;
    double _soundAndBorderTimeStamp;
    BOOL _gestureRecognized;
    BOOL _allowGesture;
    double _beatLength;
    BOOL _percentageAlreadySubtracted;
    
    double _soundTicker;
    
    CCParticleSystem *_perfectParticle;
    
    SoundDelegate *_soundDelegate;
    BeatBorder *_beatBorder;
}

-(void) didLoadFromCCB
{
    
    self.userInteractionEnabled = FALSE;
    _gestureMessageTop.string = @"";
    _gestureMessageBot.string = @"";
    _defaults = [NSUserDefaults standardUserDefaults];
   
    _timer = [Timer alloc];
    
    _gameCountdownMode = TRUE;
    _gameCountdown = 4;
    _gameStarted = FALSE;
    _gameEnded = FALSE;
    _comboMode = FALSE;
    
    _currentGestureSet = nil;
    _currentGestureSetIndex = 0;
    _totalPoints = 0;
    _soundTicker = 0;

    _gestureTimeStamp = 0;
    _soundAndBorderTimeStamp = 0;
    _gestureRecognized = FALSE;
    _beatLength = .7;
    _beatBorder.beatLength = _beatLength;
    _percentageAlreadySubtracted = FALSE;
    
    
    _fourSlap = [NSArray arrayWithObjects:  [[SlapGestures alloc] initWithTime: 1 andType: @"SLAP!"],
                                            [[SlapGestures alloc] initWithTime: 1 andType: @"SingleSlap"],
                                            [[SlapGestures alloc] initWithTime: 1 andType: @"SLAP!"],
                                            [[SlapGestures alloc] initWithTime: 1 andType: @"SingleSlap"],
                                            [[SlapGestures alloc] initWithTime: 1 andType: @"SLAP!"],
                                            [[SlapGestures alloc] initWithTime: 1 andType: @"SingleSlap"],
                                            [[SlapGestures alloc] initWithTime: 1 andType: @"SLAP!"],
                                            [[SlapGestures alloc] initWithTime: 1 andType: @"SingleSlap"], nil];
    
    _threeSlapOneDouble = [NSArray arrayWithObjects:[[SlapGestures alloc] initWithTime: 1 andType: @"SLAP!"],
                                                    [[SlapGestures alloc] initWithTime: 1 andType: @"SingleSlap"],
                                                    [[SlapGestures alloc] initWithTime: 1 andType: @"SLAP!"],
                                                    [[SlapGestures alloc] initWithTime: 1 andType: @"SingleSlap"],
                                                    [[SlapGestures alloc] initWithTime: 1 andType: @"DOUBLE      "],
                                                    [[SlapGestures alloc] initWithTime: .5 andType: @"DOUBLE SLAP!"],
                                                    [[SlapGestures alloc] initWithTime: .5 andType: @"SingleSlap"],
                                                    [[SlapGestures alloc] initWithTime: .5 andType: @"SingleSlap"],
                                                    [[SlapGestures alloc] initWithTime: .5 andType: @"SLAP!"],
                                                    [[SlapGestures alloc] initWithTime: 1 andType: @"SingleSlap"], nil];
    
    _twoDoubleOneTriple = [NSArray arrayWithObjects:[[SlapGestures alloc] initWithTime: 1 andType: @"DOUBLE      "],
                                                    [[SlapGestures alloc] initWithTime: .5 andType: @"DOUBLE SLAP!"],
                                                    [[SlapGestures alloc] initWithTime: .5 andType: @"SingleSlap"],
                                                    [[SlapGestures alloc] initWithTime: .5 andType: @"SingleSlap"],
                                                    [[SlapGestures alloc] initWithTime: .5 andType: @"DOUBLE      "],
                                                    [[SlapGestures alloc] initWithTime: .5 andType: @"DOUBLE SLAP!"],
                                                    [[SlapGestures alloc] initWithTime: .5 andType: @"SingleSlap"],
                                                    [[SlapGestures alloc] initWithTime: .5 andType: @"SingleSlap"],
                                                    [[SlapGestures alloc] initWithTime: .5 andType: @"TRIPLE SLAP!"],
                                                    [[SlapGestures alloc] initWithTime: 1 andType: @"LeftSlap"],
                                                    [[SlapGestures alloc] initWithTime: 1 andType: @"RightSlap"],
                                                    [[SlapGestures alloc] initWithTime: 1 andType: @"UpSlap"], nil];

    _twoSlapOneDown = [NSArray arrayWithObjects:[[SlapGestures alloc] initWithTime: 1 andType: @"SLAP!"],
                                                [[SlapGestures alloc] initWithTime: 1 andType: @"SingleSlap"],
                                                [[SlapGestures alloc] initWithTime: 1 andType: @"SLAP!"],
                                                [[SlapGestures alloc] initWithTime: 1 andType: @"SingleSlap"],
                                                [[SlapGestures alloc] initWithTime: 1 andType: @"HEAD BASH!"],
                                                [[SlapGestures alloc] initWithTime: 2 andType: @"DownSlap"],
                                                [[SlapGestures alloc] initWithTime: 1 andType: @"PAUSE"] ,nil];

    
    _queue = [NSMutableArray arrayWithObjects: _fourSlap, _threeSlapOneDouble, _twoDoubleOneTriple, _twoSlapOneDown,  nil];
    
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
    
    _perfectParticle = (CCParticleSystem*)[CCBReader load:@"Particles/PerfectParticle"];
    
    _whiteNode.zOrder = -4;
    _colorGradientNode.zOrder = -3;
    _glowNode.zOrder = -2;
    
    _soundDelegate = [[SoundDelegate alloc] init];
    
}

-(void) update:(CCTime)delta
{
    _timer.currentTime += delta;
    _gestureTimeStamp += delta;
    _timer.comboTimeKeeper += delta;
    _soundTicker += delta;
    _soundAndBorderTimeStamp += delta;
    
    if (!_gameStarted)
    {
        if (_gameCountdownMode)
        {
            if (_soundAndBorderTimeStamp >= _beatLength && _gameCountdown < 4) {
                [_beatBorder beat];
                [_soundDelegate playMed];
                _soundAndBorderTimeStamp = 0;
                
            }
            if (_timer.currentTime >= 2*_beatLength)
            {
                if (_gameCountdown == 1)
                {
                    _gestureMessageTop.string = @"1";
                    [self performSelector:@selector(startGame) withObject:nil afterDelay:_beatLength];
                }
                else if (_gameCountdown == 4)
                {
                    _gestureMessageTop.string = @"SLAP TO THE BEAT!";
                }
                else if (_gameCountdown < 4 && _gameCountdown > 1)
                {
                    _gestureMessageTop.string = [NSString stringWithFormat:@"%i", _gameCountdown];
                }
                _timer.currentTime = 0;
                _gameCountdown--;
            }
        }
    }
    else if (!_gameEnded)
    {
        if (_comboMode && _timer.comboTimeKeeper >= _beatLength)
        {
            _pointMultiplier++;
            _timer.comboTimeKeeper = 0;
            _comboModeLabel.string = [NSString stringWithFormat:@"COMBO MODE x%i", _pointMultiplier];
        }
        
        if (_soundAndBorderTimeStamp >= _beatLength) {
            [_beatBorder beat];
            _soundAndBorderTimeStamp = 0;
        }
        
        if (_currentNumOfBeats >= _waveNumOfBeats)
        {
            
            [self performSelector:@selector(delayWaveMessage) withObject:nil afterDelay:2 * _beatLength];
            _beatLength -= .05;
            _beatBorder.beatLength = _beatLength;
            
            _gestureRecognized = TRUE;
            _allowGesture = FALSE;
            
            _gameStarted = FALSE;
            _gameCountdownMode = TRUE;
            _gameCountdown = 4;
            _timer.currentTime = 0;
            _gestureTimeStamp = 0;
        }
        
        _currentGesture = _currentGestureSet[_currentGestureSetIndex];
        
        if (([_currentGesture.typeOfSlapNeeded isEqual:@"SLAP!"]
             || [_currentGesture.typeOfSlapNeeded isEqual:@"DOUBLE SLAP!"]
             || [_currentGesture.typeOfSlapNeeded isEqual:@"TRIPLE SLAP!"]
             || [_currentGesture.typeOfSlapNeeded isEqual:@"DOUBLE      "]
             || [_currentGesture.typeOfSlapNeeded isEqual:@"HEAD BASH!"]
             || [_currentGesture.typeOfSlapNeeded isEqual:@"PAUSE"]) && (_timer.currentTime >= _currentGesture.timeStamp * _beatLength))
        {
            if (![_currentGesture.typeOfSlapNeeded isEqual:@"PAUSE"])
            {
                _gestureMessageTop.string = _currentGesture.typeOfSlapNeeded;
                _gestureMessageBot.string = @"";
                [_face reset];
                
                //SECOND DOUBLE SLAP ISN'T PLAYING
                [_soundDelegate playMed];
            }
            
            _gestureRecognized  = FALSE;
            _allowGesture = TRUE;
            _currentGestureSetIndex++;
            _currentNumOfBeats+=_currentGesture.timeStamp;
            _timer.currentTime = 0;
            _gestureTimeStamp = 0;
        }
        else if (_gestureRecognized && _timer.currentTime >= _currentGesture.timeStamp * _beatLength)
        {
            _gestureTimeStamp = 0;
            _timer.currentTime = 0;
            _currentNumOfBeats +=_currentGesture.timeStamp;
            _currentGestureSetIndex++;
            _gestureRecognized = FALSE;
            _allowGesture = TRUE;
            
        }
        else if (!_gestureRecognized && _timer.currentTime >= (_currentGesture.timeStamp * 1.2) * _beatLength)
        {
            _gestureTimeStamp = _currentGesture.timeStamp*.2*_beatLength;
            _timer.currentTime = _currentGesture.timeStamp*.2*_beatLength;
            _currentGestureSetIndex++;
            _currentNumOfBeats +=_currentGesture.timeStamp;
            _gestureRecognized = FALSE;
            _allowGesture = TRUE;
            
            _gestureMessageBot.string = @"TOO LATE!";
            _gestureMessageBot.color = [CCColor redColor];
            [self setPercentage: -6* _currentGesture.timeStamp];
                

        }
        if (_currentGestureSetIndex >= [_currentGestureSet count])
        {
            [self loadNewGesture];
        }
    }
}

-(void) delayWaveMessage
{
    if (_tutorialMode)
    {
        _gestureMessageTop.string = @"TUTORIAL COMPLETE";
        _gestureMessageBot.string = @"";
        
    }
    else
    {
        _gestureMessageTop.string = @"WAVE COMPLETE";
        _gestureMessageBot.string = @"";
    }
}

-(void) swipeLeft
{
    if (!_gestureRecognized && _allowGesture)
    {
        [_face hitLeft];
        [_soundDelegate playLeft];
        double convertedTime = _currentGesture.timeStamp * _beatLength;
        if ([_currentGesture.typeOfSlapNeeded isEqual: @"SingleSlap"] || [_currentGesture.typeOfSlapNeeded isEqual:@"LeftSlap"])
        {
            [self checkForAccuracy:convertedTime];
        }
        else
        {
            _gestureMessageBot.string = @"WRONG SLAP";
            _gestureMessageBot.color = [CCColor redColor];
            [self setPercentage: -6 * _currentGesture.timeStamp];
            [self addScore: -25];
        }
        _gestureRecognized = TRUE;
        _allowGesture = FALSE;
    }
}
-(void) swipeRight
{
    if (!_gestureRecognized && _allowGesture)
    {
        [_face hitRight];
        [_soundDelegate playRight];
        double convertedTime = _currentGesture.timeStamp * _beatLength;
        if ([_currentGesture.typeOfSlapNeeded isEqual: @"SingleSlap"] || [_currentGesture.typeOfSlapNeeded isEqual:@"RightSlap"])
        {
            [self checkForAccuracy:convertedTime];
            
        }
        else
        {
            _gestureMessageBot.string = @"WRONG SLAP";
            _gestureMessageBot.color = [CCColor redColor];
            [self setPercentage: -6 * _currentGesture.timeStamp];
            [self addScore: -25];
        }
        _gestureRecognized = TRUE;
        _allowGesture = FALSE;
    }
}
-(void) swipeUp
{
    if (!_gestureRecognized && _allowGesture)
    {
        [_face hitUp];
        [_soundDelegate playUp];
        double convertedTime = _currentGesture.timeStamp * _beatLength;
        if ([_currentGesture.typeOfSlapNeeded isEqual:@"UpSlap"])
        {
            [self checkForAccuracy:convertedTime];
        }
        else
        {
            _gestureMessageBot.string = @"WRONG SLAP";
            _gestureMessageBot.color = [CCColor redColor];
            [self setPercentage: -6 * _currentGesture.timeStamp];
            [self addScore: -25];
        }
        _gestureRecognized = TRUE;
        _allowGesture = FALSE;
    }
}

-(void) swipeDown
{
    if (!_gestureRecognized && _allowGesture)
    {
        [_face hitDown];
        [_soundDelegate playDown];
        double convertedTime = _currentGesture.timeStamp * _beatLength;
        if ([_currentGesture.typeOfSlapNeeded isEqual:@"DownSlap"])
        {
            [self checkForAccuracy:convertedTime];
        }
        else
        {
            _gestureMessageBot.string = @"WRONG SLAP";
            _gestureMessageBot.color = [CCColor redColor];
            [self setPercentage: -6 * _currentGesture.timeStamp];
            [self addScore: -25];
        }
        _gestureRecognized = TRUE;
        _allowGesture = FALSE;
    }
}

-(void) checkForAccuracy: (double) convertedTime
{
    if (_gestureTimeStamp < 1.05 * convertedTime && _gestureTimeStamp > .95 * convertedTime)
    {
        _gestureMessageBot.string = @"PERFECT!";
        _gestureMessageBot.color = [CCColor yellowColor];
        
        [self loadParticleExplosionWithPosition: ccp(_gestureMessageBot.positionInPoints.x, _gestureMessageBot.positionInPoints.y) andParticle:_perfectParticle];
        
        [self setPercentage: 6 * _currentGesture.timeStamp];
        [self addScore: 50];
    }
    else if (_gestureTimeStamp < 1.10 * convertedTime && _gestureTimeStamp > .9 * convertedTime)
    {
        _gestureMessageBot.string = @"GOOD";
        _gestureMessageBot.color = [CCColor cyanColor];
        [self setPercentage: 4 * _currentGesture.timeStamp];
        [self addScore: 25];
    }
    else if (_gestureTimeStamp < 1.20 * convertedTime && _gestureTimeStamp > .8 * convertedTime)
    {
        _gestureMessageBot.string = @"OK";
        _gestureMessageBot.color = [CCColor whiteColor];
        [self setPercentage: 2 * _currentGesture.timeStamp];
        [self addScore: 10];
    }
    else if (_gestureTimeStamp <= .8 * convertedTime)
    {
        _gestureMessageBot.string = @"TOO EARLY!";
        _gestureMessageBot.color = [CCColor redColor];
        [self setPercentage: -6 * _currentGesture.timeStamp];
        [self addScore: -25];
    }

}

-(void) setPercentage: (int) percent
{
    _comboBar.currentSize += percent;
    if (percent < 0)
    {
        [_soundDelegate playLow];
        if (_comboMode)
        {
            [_comboBar loadParticleExplosionWithColor:[CCColor whiteColor]];
        }
        else if (_comboBar.currentSize <33)
        {
            [_comboBar loadParticleExplosionWithColor:[CCColor redColor]];
        }
        else
        {
            [_comboBar loadParticleExplosionWithColor:[CCColor cyanColor]];
        }
    }
    
    if (_comboBar.currentSize>= 100)
    {
        _comboBar.currentSize = 100;
        _comboMode = TRUE;
        _colorGradientNode.visible = TRUE;
        _glowNode.visible = TRUE;
        _comboBar.comboBarGradient.visible = TRUE;
        _comboBar.comboGlowNode.visible = TRUE;
        _comboModeLabel.visible = TRUE;
    }
    else
    {
        _comboMode = FALSE;
        _pointMultiplier = 1;
        _colorGradientNode.visible = FALSE;
        _glowNode.visible = FALSE;
        _comboBar.comboBarGradient.visible = FALSE;
        _comboBar.comboGlowNode.visible = FALSE;
        _comboModeLabel.visible = FALSE;
    }
    
    if (_comboBar.currentSize <= 0)
    {
        _comboBar.currentSize = 0;
        _gameEnded = TRUE;
        _gameStarted = FALSE;
        
        //put in information about
        _gestureMessageTop.string = @"";
        _totalScoreLabel.string = @"";
    
        id move = [CCActionMoveTo actionWithDuration:2 position:ccp(.5, -50)];
        id moveElastic = [CCActionEaseElasticInOut actionWithAction: move period:.3];
        [_comboBar runAction: moveElastic];
        
        id jump1 = [CCActionJumpTo actionWithDuration:2 position: ccp(.3, -2) height:5 jumps:1];
        [_face runAction:jump1];
        
        [self performSelector:@selector(endGame) withObject:nil afterDelay:2];
    }
}

-(void) startGame
{
    _gameCountdownMode = FALSE;
    _gameStarted = TRUE;
    _currentGestureSet = [_queue objectAtIndex:0];
    _timer.currentTime = 0;
    _gestureTimeStamp = 0;
    _currentNumOfBeats = 0;
    _soundAndBorderTimeStamp = 0;
    _waveNumOfBeats = 32;
    
    [_beatBorder beat];
    [_soundDelegate playMed];
    
//    [_medBeatAudioPlayer performSelector:@selector(prepareToPlay) withObject:nil afterDelay:_beatLength];
//    [_medBeatAudioPlayer performSelector:@selector(play) withObject:nil afterDelay:_beatLength];
}

-(void) endGame
{
    self.userInteractionEnabled = FALSE;
    GameEndPopUp *postGamePopUp = (GameEndPopUp *)[CCBReader load: @"PostGamePopUp"];
    postGamePopUp.userInteractionEnabled = TRUE;
    postGamePopUp.positionType = CCPositionTypePoints;
    postGamePopUp.position = ccp(self.contentSizeInPoints.width*.5,self.contentSizeInPoints.height * .5);
    
    postGamePopUp.yourScoreNum.string = [NSString stringWithFormat:@"%i", _totalScore];
    if ([_defaults objectForKey:@"highScore"] == nil || _totalScore > [[_defaults objectForKey:@"highScore"] intValue])
    {
        postGamePopUp.highScoreTitle.string = @"NEW HIGH SCORE";
        [_defaults setObject:[NSNumber numberWithInt: _totalScore] forKey:@"highScore"];
        [_defaults synchronize];
    }
    postGamePopUp.highScoreNum.string = [NSString stringWithFormat:@"%i",[[_defaults objectForKey:@"highScore"] intValue]];
    [self addChild:postGamePopUp];
    
}

-(void) loadNewGesture
{
    [_queue removeObjectAtIndex: 0];
    _currentGestureSet = nil;
    NSArray *generatedGesture = nil;
    switch (arc4random()%4)
    {
        case 0: generatedGesture = _fourSlap;
            break;
        case 1: generatedGesture = _threeSlapOneDouble;
            break;
        case 2: generatedGesture = _twoDoubleOneTriple;
            break;
        case 3: generatedGesture = _twoSlapOneDown;
            break;
    }
    [_queue addObject: generatedGesture];
    _currentGestureSetIndex = 0;
    _currentGestureSet = [_queue objectAtIndex:0];
}

-(void)loadParticleExplosionWithPosition: (CGPoint) position andParticle: (CCParticleSystem*) particle {
    CCParticleSystem *explosion = particle;
    [explosion removeFromParent];
    [explosion resetSystem];
    explosion.autoRemoveOnFinish = TRUE;
    explosion.position = position;
    [self addChild: explosion];
}

-(void) addScore: (int) score
{
    _totalScore += score * _pointMultiplier *_currentGesture.timeStamp;
    _totalScoreLabel.string = [NSString stringWithFormat:@"%i", _totalScore];
}

-(void) resetDefaults
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}
@end
