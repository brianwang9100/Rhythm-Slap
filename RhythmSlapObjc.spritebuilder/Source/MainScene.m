//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#define ARC4RANDOM_MAX 0x100000000

@implementation MainScene
{
    Hand *_hand;
    Face *_face;
    Timer *_timer;
    ComboBar *_comboBar;
    CCNodeGradient *_colorGradientNode;
    CCNodeColor *_glowNode;
    CCLabelTTF *_gestureMessage;
    NSUserDefaults _defaults;

    int _currentNumOfBeats;
    int _waveNumOfBeats;
   
    int _pointMultiplier;
    int _totalScore;
    
    CCLabelTTF *_totalScoreLabel;

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

    int _comboBarSize;

    NSArray *_currentGestureSet;
    int _currentGestureSetIndex;
    SlapGestures *_currentGesture;
    int _totalPoints;

    UISwipeGestureRecognizer *_swipeLeft;
    UISwipeGestureRecognizer *_swipeRight;
    UISwipeGestureRecognizer *_swipeUp;
    UISwipeGestureRecognizer *_swipeDown;
    
    float _gestureTimeStamp;
    BOOL _gestureRecognized;
    BOOL _allowGesture;
    float _beatLength;
    BOOL _percentageAlreadySubtracted;
}

-(void) didLoadFromCCB
{
    self.userInteractionEnabled = FALSE;
    _gestureMessage.string = @"";
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

    _gestureTimeStamp = 0;
    _gestureRecognized = FALSE;
    _beatLength = .7;
    _percentageAlreadySubtracted = FALSE;
    
//    _fourSlap = [NSArray arrayWithObjects: [SingleSlap alloc],[SingleSlap alloc], [SingleSlap alloc], [SingleSlap alloc], nil];
//    _threeSlapOneDouble = [NSArray arrayWithObjects: [SingleSlap alloc],[SingleSlap alloc], [SingleSlap alloc], [DoubleSlap alloc], nil];
//    _twoDoubleOneTriple = [NSArray arrayWithObjects: [DoubleSlap alloc],[DoubleSlap alloc], [TripleSlap alloc], nil];
//    _twoSlapOneDown = [NSArray arrayWithObjects: [SingleSlap alloc],[SingleSlap alloc], [SlapDown alloc], nil];
    
    
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
                                                    [[SlapGestures alloc] initWithTime: 1 andType: @"DOUBLE SLAP!"],
                                                    [[SlapGestures alloc] initWithTime: 1 andType: @"LeftSlap"],
                                                    [[SlapGestures alloc] initWithTime: .5 andType: @"RightSlap"],
                                                    [[SlapGestures alloc] initWithTime: .5 andType: @"SLAP!"],
                                                    [[SlapGestures alloc] initWithTime: 1 andType: @"SingleSlap"], nil];
    
    _twoDoubleOneTriple = [NSArray arrayWithObjects:[[SlapGestures alloc] initWithTime: 1 andType: @"DOUBLE SLAP!"],
                                                    [[SlapGestures alloc] initWithTime: 1 andType: @"LeftSlap"],
                                                    [[SlapGestures alloc] initWithTime: .5 andType: @"RightSlap"],
                                                    [[SlapGestures alloc] initWithTime: .5 andType: @"DOUBLE SLAP!"],
                                                    [[SlapGestures alloc] initWithTime: 1 andType: @"LeftSlap"],
                                                    [[SlapGestures alloc] initWithTime: .5 andType: @"RightSlap"],
                                                    [[SlapGestures alloc] initWithTime: .5 andType: @"TRIPLE SLAP!"],
                                                    [[SlapGestures alloc] initWithTime: 1 andType: @"LeftSlap"],
                                                    [[SlapGestures alloc] initWithTime: 1 andType: @"RightSlap"],
                                                    [[SlapGestures alloc] initWithTime: 1 andType: @"UpSlap"], nil];

    _twoSlapOneDown = [NSArray arrayWithObjects:[[SlapGestures alloc] initWithTime: 1 andType: @"SLAP!"],
                                                [[SlapGestures alloc] initWithTime: 1 andType: @"SingleSlap"],
                                                [[SlapGestures alloc] initWithTime: 1 andType: @"SLAP!"],
                                                [[SlapGestures alloc] initWithTime: 1 andType: @"SingleSlap"],
                                                [[SlapGestures alloc] initWithTime: 1 andType: @"HEAD BASH!"],
                                                [[SlapGestures alloc] initWithTime: 3 andType: @"DownSlap"], nil];

    
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
}

-(void) update:(CCTime)delta
{
    _timer.currentTime += delta;
    _gestureTimeStamp += delta;
    _timer.comboTimeKeeper += delta;
    
    if (!_gameStarted)
    {
        if (_gameCountdownMode)
        {
            if (_timer.currentTime >= 2*_beatLength)
            {
                if (_gameCountdown == 0)
                {
                    _gestureMessage.string = @"START!";
                    [self performSelector:@selector(startGame) withObject:nil afterDelay:_beatLength];
                    //[self startGame];
                }
                else if (_gameCountdown < 4 && _gameCountdown > 0)
                {
                    _gestureMessage.string = [NSString stringWithFormat:@"%i", _gameCountdown];
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
            _colorGradientNode.startColor = [CCColor grayColor];
            _glowNode.visible = TRUE;
            _comboBar.comboBarGradient.visible = TRUE;
            _comboBar.comboGlowNode.visible = TRUE;
            
        }
        else
        {
            _pointMultiplier = 1;
            _colorGradientNode.startColor = [CCColor whiteColor];
            _glowNode.visible = FALSE;
            _comboBar.comboBarGradient.visible = FALSE;
            _comboBar.comboGlowNode.visible = FALSE;
        }
        
        if (_currentNumOfBeats >= _waveNumOfBeats)
        {
            [self performSelector:@selector(delayWaveMessage) withObject:nil afterDelay:2 * _beatLength];
            
            _beatLength -= .05;
            
            _gestureRecognized = TRUE;
            _allowGesture = FALSE;
            
            _gameStarted = FALSE;
            _gameCountdownMode = TRUE;
            _gameCountdown = 4;
            _timer.currentTime = 0;
            _gestureTimeStamp = 0;
        }
        
        if (_currentGestureSet ==_fourSlap)
        {
            _currentGesture = _fourSlap[_currentGestureSetIndex];
            
            if ([_currentGesture.typeOfSlapNeeded isEqual:@"SLAP!"]&& (_timer.currentTime >= _currentGesture.timeStamp * _beatLength))
            {
                    _gestureMessage.string = _currentGesture.typeOfSlapNeeded;
                    [self performSelector:@selector(delayAllowanceOfGesture) withObject:nil afterDelay: .2 * _beatLength];
                    _currentGestureSetIndex++;
                    _currentNumOfBeats+=_currentGesture.timeStamp;
                
                    _timer.currentTime = 0;
                    _gestureTimeStamp = 0;
            }
            else
            {
                if (!_gestureRecognized && _timer.currentTime >= (_currentGesture.timeStamp + .2) * _beatLength)
                {
                    _gestureTimeStamp = .2*_beatLength;
                    _timer.currentTime = .2*_beatLength;
                    _currentGestureSetIndex++;
                    
                    _gestureMessage.string = @"TOO LATE!";
                    [self setPercentage: -6* _currentGesture.timeStamp];
                    
                    _gestureRecognized = FALSE;
                    _allowGesture = TRUE;
                    _currentNumOfBeats +=_currentGesture.timeStamp;
                }
                else if (_gestureRecognized && _timer.currentTime >= _currentGesture.timeStamp * _beatLength)
                {
                    _gestureTimeStamp = 0;
                    _timer.currentTime = 0;
                    _currentGestureSetIndex++;
                    
                    _gestureRecognized = FALSE;
                    _allowGesture = TRUE;
                    _currentNumOfBeats +=_currentGesture.timeStamp;
                }
                
                if (_currentGestureSetIndex >= [_fourSlap count])
                {
                    [self loadNewGesture];
                }
            }
    
        }
        else if (_currentGestureSet == _threeSlapOneDouble)
        {
            _currentGesture = _threeSlapOneDouble[_currentGestureSetIndex];
            
            if (([_currentGesture.typeOfSlapNeeded isEqual:@"SLAP!"] || [_currentGesture.typeOfSlapNeeded isEqual:@"DOUBLE SLAP!"]) && (_timer.currentTime >= _currentGesture.timeStamp * _beatLength))
            {
                _gestureMessage.string = _currentGesture.typeOfSlapNeeded;
                
                [self performSelector:@selector(delayAllowanceOfGesture) withObject:nil afterDelay: .2 * _beatLength];
                _currentGestureSetIndex++;
                _currentNumOfBeats+=_currentGesture.timeStamp;
                _timer.currentTime = 0;
                _gestureTimeStamp = 0;
            }
            else
            {
                if (!_gestureRecognized && _timer.currentTime >= (_currentGesture.timeStamp + .2) * _beatLength)
                {
                    _gestureTimeStamp = .2 * _beatLength;
                    _timer.currentTime = .2 * _beatLength;
                    _currentGestureSetIndex++;
                    
                    _gestureMessage.string = @"TOO LATE!";
                    [self setPercentage: -6 * _currentGesture.timeStamp];
                    
                    _gestureRecognized = FALSE;
                    _allowGesture = TRUE;
                    _currentNumOfBeats +=_currentGesture.timeStamp;
                }
                else if (_gestureRecognized && _timer.currentTime >= _currentGesture.timeStamp * _beatLength)
                {
                    _gestureTimeStamp = 0;
                    _timer.currentTime = 0;
                    _currentGestureSetIndex++;
                    
                    _gestureRecognized = FALSE;
                    _allowGesture = TRUE;
                    _currentNumOfBeats +=_currentGesture.timeStamp;
                }
                
                if (_currentGestureSetIndex >= [_threeSlapOneDouble count])
                {
                    [self loadNewGesture];
                }
            }
        }
        else if (_currentGestureSet == _twoDoubleOneTriple)
        {
            _currentGesture = _twoDoubleOneTriple[_currentGestureSetIndex];
            
            if (([_currentGesture.typeOfSlapNeeded isEqual:@"DOUBLE SLAP!"] || [_currentGesture.typeOfSlapNeeded isEqual:@"TRIPLE SLAP!"]) && (_timer.currentTime >= _currentGesture.timeStamp * _beatLength))
            {
                _gestureMessage.string = _currentGesture.typeOfSlapNeeded;
                [self performSelector:@selector(delayAllowanceOfGesture) withObject:nil afterDelay: .2 * _beatLength];
                _currentGestureSetIndex++;
                _currentNumOfBeats+=_currentGesture.timeStamp;
                _timer.currentTime = 0;
                _gestureTimeStamp = 0;
            }
            else
            {
                if (!_gestureRecognized && _timer.currentTime >= (_currentGesture.timeStamp + .2) * _beatLength)
                {
                    _gestureTimeStamp = .2*_beatLength;
                    _timer.currentTime = .2*_beatLength;
                    _currentGestureSetIndex++;
                    
                    _gestureMessage.string = @"TOO LATE!";
                    [self setPercentage: -6* _currentGesture.timeStamp];
                    
                    _gestureRecognized = FALSE;
                    _allowGesture = TRUE;
                    _currentNumOfBeats +=_currentGesture.timeStamp;
                }
                else if (_gestureRecognized && _timer.currentTime >= _currentGesture.timeStamp * _beatLength)
                {
                    _gestureTimeStamp = 0;
                    _timer.currentTime = 0;
                    _currentGestureSetIndex++;
                    
                    _gestureRecognized = FALSE;
                    _allowGesture = TRUE;
                    _currentNumOfBeats +=_currentGesture.timeStamp;
                }
                
                if (_currentGestureSetIndex >= [_twoDoubleOneTriple count])
                {
                    [self loadNewGesture];
                }
            }
        }
        else if (_currentGestureSet == _twoSlapOneDown)
        {
            _currentGesture = _twoSlapOneDown[_currentGestureSetIndex];
            
            if (([_currentGesture.typeOfSlapNeeded isEqual:@"SLAP!"] || [_currentGesture.typeOfSlapNeeded isEqual:@"HEAD BASH!"]) && (_timer.currentTime >= _currentGesture.timeStamp * _beatLength))
            {
                _gestureMessage.string = _currentGesture.typeOfSlapNeeded;
                
                [self performSelector:@selector(delayAllowanceOfGesture) withObject:nil afterDelay: .2 * _beatLength];
                _currentGestureSetIndex++;
                _currentNumOfBeats+=_currentGesture.timeStamp;
                _timer.currentTime = 0;
                _gestureTimeStamp = 0;
            }
            else
            {
                if (!_gestureRecognized && _timer.currentTime >= (_currentGesture.timeStamp + .2) * _beatLength)
                {
                    _gestureTimeStamp = .2 * _beatLength;
                    _timer.currentTime = .2 * _beatLength;
                    _currentGestureSetIndex ++;
                    
                    _gestureMessage.string = @"TOO LATE!";
                    [self setPercentage: -6 * _currentGesture.timeStamp];
                    
                    _gestureRecognized = FALSE;
                    _allowGesture = TRUE;
                    _currentNumOfBeats +=_currentGesture.timeStamp;
                }
                else if (_gestureRecognized && _timer.currentTime >= _currentGesture.timeStamp * _beatLength)
                {
                    _gestureTimeStamp = 0;
                    _timer.currentTime = 0;
                    _currentGestureSetIndex++;
                    
                    _gestureRecognized = FALSE;
                    _allowGesture = TRUE;
                    _currentNumOfBeats +=_currentGesture.timeStamp;
                }
                
                if (_currentGestureSetIndex >= [_twoSlapOneDown count])
                {
                    [self loadNewGesture];
                }
            }

        }
    }
}
-(void) delayWaveMessage
{
    _gestureMessage.string = @"WAVE COMPLETE";
}

-(void) delayAllowanceOfGesture
{
    _gestureRecognized  = FALSE;
    _allowGesture = TRUE;
}

-(void) swipeLeft
{
    if (!_gestureRecognized && _allowGesture)
    {
        float convertedTime = _currentGesture.timeStamp * _beatLength;
        if ([_currentGesture.typeOfSlapNeeded isEqual: @"SingleSlap"] || [_currentGesture.typeOfSlapNeeded isEqual:@"LeftSlap"])
        {
            if (_gestureTimeStamp < 1.05 * convertedTime && _gestureTimeStamp > .95 * convertedTime)
            {
                _gestureMessage.string = @"PERFECT!";
                [self setPercentage: 6 * _currentGesture.timeStamp];
                [self addScore: 50];
            }
            else if (_gestureTimeStamp < 1.10 * convertedTime && _gestureTimeStamp > .9 * convertedTime)
            {
                _gestureMessage.string = @"GOOD";
                [self setPercentage: 4 * _currentGesture.timeStamp];
                [self addScore: 25];
            }
            else if (_gestureTimeStamp < 1.20 * convertedTime && _gestureTimeStamp > .8 * convertedTime)
            {
                _gestureMessage.string = @"OK";
                [self setPercentage: 2 * _currentGesture.timeStamp];
                [self addScore: 10];
            }
            else if (_gestureTimeStamp <= .8 * convertedTime)
            {
                _gestureMessage.string = @"TOO EARLY!";
                [self setPercentage: -6 * _currentGesture.timeStamp];
                [self addScore: -25];
            }
        }
        else
        {
            _gestureMessage.string = @"WRONG SLAP";
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
        float convertedTime = _currentGesture.timeStamp * _beatLength;
        if ([_currentGesture.typeOfSlapNeeded isEqual: @"SingleSlap"] || [_currentGesture.typeOfSlapNeeded isEqual:@"RightSlap"])
        {
            if (_gestureTimeStamp < 1.05 * convertedTime && _gestureTimeStamp > .95 * convertedTime)
            {
                _gestureMessage.string = @"PERFECT!";
                [self setPercentage: 6 * _currentGesture.timeStamp];
                [self addScore: 50];
            }
            else if (_gestureTimeStamp < 1.10 * convertedTime && _gestureTimeStamp > .9 * convertedTime)
            {
                _gestureMessage.string = @"GOOD";
                [self setPercentage: 4 * _currentGesture.timeStamp];
                [self addScore: 25];
            }
            else if (_gestureTimeStamp < 1.20 * convertedTime && _gestureTimeStamp > .8 * convertedTime)
            {
                _gestureMessage.string = @"OK";
                [self setPercentage: 2 * _currentGesture.timeStamp];
                [self addScore: 10];
            }
            else if (_gestureTimeStamp <= .8 * convertedTime)
            {
                _gestureMessage.string = @"TOO EARLY!";
                [self setPercentage: -6 * _currentGesture.timeStamp];
                [self addScore: -25];
            }
            
        }
        else
        {
            _gestureMessage.string = @"WRONG SLAP";
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
        float convertedTime = _currentGesture.timeStamp * _beatLength;
        if ([_currentGesture.typeOfSlapNeeded isEqual:@"UpSlap"])
        {
            if (_gestureTimeStamp < 1.05 * convertedTime && _gestureTimeStamp > .95 * convertedTime)
            {
                _gestureMessage.string = @"PERFECT!";
                [self setPercentage: 6 * _currentGesture.timeStamp];
                [self addScore: 50];
            }
            else if (_gestureTimeStamp < 1.10 * convertedTime && _gestureTimeStamp > .9 * convertedTime)
            {
                _gestureMessage.string = @"GOOD";
                [self setPercentage: 4 * _currentGesture.timeStamp];
                [self addScore: 25];
            }
            else if (_gestureTimeStamp < 1.20 * convertedTime && _gestureTimeStamp > .8 * convertedTime)
            {
                _gestureMessage.string = @"OK";
                [self setPercentage: 2 * _currentGesture.timeStamp];
                [self addScore: 10];
            }
            else if (_gestureTimeStamp <= .8 * convertedTime)
            {
                _gestureMessage.string = @"TOO EARLY!";
                [self setPercentage: -6 * _currentGesture.timeStamp];
                [self addScore: -25];
            }
            
        }
        else
        {
            _gestureMessage.string = @"WRONG SLAP";
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
        float convertedTime = _currentGesture.timeStamp * _beatLength;
        if ([_currentGesture.typeOfSlapNeeded isEqual:@"DownSlap"])
        {
            if (_gestureTimeStamp < 1.05 * convertedTime && _gestureTimeStamp > .95 * convertedTime)
            {
                _gestureMessage.string = @"PERFECT!";
                [self setPercentage: 6 * _currentGesture.timeStamp];
                [self addScore: 50];
            }
            else if (_gestureTimeStamp < 1.10 * convertedTime && _gestureTimeStamp > .9 * convertedTime)
            {
                _gestureMessage.string = @"GOOD";
                [self setPercentage: 4 * _currentGesture.timeStamp];
                [self addScore: 25];
            }
            else if (_gestureTimeStamp < 1.20 * convertedTime && _gestureTimeStamp > .8 * convertedTime)
            {
                _gestureMessage.string = @"OK";
                [self setPercentage: 2 * _currentGesture.timeStamp];
                [self addScore: 10];
            }
            else if (_gestureTimeStamp <= .8 * convertedTime)
            {
                _gestureMessage.string = @"TOO EARLY!";
                [self setPercentage: -6 * _currentGesture.timeStamp];
                [self addScore: -25];
            }
            
        }
        else
        {
            _gestureMessage.string = @"WRONG SLAP";
            [self setPercentage: -6 * _currentGesture.timeStamp];
            [self addScore: -25];
        }
        _gestureRecognized = TRUE;
        _allowGesture = FALSE;
    }
}

-(void) setPercentage: (int) percent
{
    _comboBar.currentSize += percent;
    
    if (_comboBar.currentSize>= 100)
    {
        _comboBar.currentSize = 100;
        _comboMode = TRUE;
    }
    else
    {
        _comboMode = FALSE;
    }
    
    if (_comboBar.currentSize <= 0)
    {
        _comboBar.currentSize = 0;
        _gameEnded = TRUE;
        _gameStarted = FALSE;
        
        //put in information about
        _gestureMessage.string = @"";
    
        id move = [CCActionMoveTo actionWithDuration:2 position:ccp(.5, -50)];
        id moveElastic = [CCActionEaseElasticInOut actionWithAction: move period:.3];
        [_comboBar runAction: moveElastic];
        
        id jump1 = [CCActionJumpTo actionWithDuration:2 position: ccp(.3, -2) height:50 jumps:1];
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
    _waveNumOfBeats = 32;
}

-(void) endGame
{
    self.userInteractionEnabled = FALSE;
    GameEndPopUp *postGamePopUp = [CCBReader load: @"PostGamePopUp"];
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
    NSArray *generatedGesture = nil;
    switch (arc4random()%3)
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

-(void)loadParticleExplosionWithParticleName: (NSString *) particleName onObject: (CCNode*) object withColor: (CCColor*) color
{
    @synchronized(self)
    {
        CCParticleSystem *explosion = (CCParticleSystem*)[CCBReader load: [NSString stringWithFormat:@"%@Particle", particleName]];
        explosion.autoRemoveOnFinish = TRUE;
        explosion.position = object.position;
        explosion.startColor = color;
        explosion.endColor = color;
        [self addChild: explosion];
    }
}
-(void)loadParticleExplosionWithParticleName: (NSString *) particleName onObject: (CCNode*) object withDirection: (NSString*) direction{
    @synchronized(self)
    {
        CCParticleSystem *explosion = (CCParticleSystem*)[CCBReader load: [NSString stringWithFormat:@"%@Particle%@", particleName, direction]];
        explosion.autoRemoveOnFinish = TRUE;
        explosion.position = object.position;
        [self addChild: explosion];
    }
}

-(void) addScore: (int) score
{
    _totalScore += score * _pointMultiplier *_currentGesture.timeStamp;
    _totalScoreLabel.string = [NSString stringWithFormat:@"%i", _totalScore];
}

@end
