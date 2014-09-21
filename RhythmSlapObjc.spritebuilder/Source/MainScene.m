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

    int _currentNumOfBeats;
    int _waveNumOfBeats;

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
    
    _fourSlap = [NSArray arrayWithObjects: [SingleSlap alloc],[SingleSlap alloc], [SingleSlap alloc], [SingleSlap alloc], nil];
    _threeSlapOneDouble = [NSArray arrayWithObjects: [SingleSlap alloc],[SingleSlap alloc], [SingleSlap alloc], [DoubleSlap alloc], nil];
    _twoDoubleOneTriple = [NSArray arrayWithObjects: [DoubleSlap alloc],[DoubleSlap alloc], [TripleSlap alloc], nil];
    _twoSlapOneDown = [NSArray arrayWithObjects: [SingleSlap alloc],[SingleSlap alloc], [SlapDown alloc], nil];
    
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
        if (_currentNumOfBeats >= _waveNumOfBeats)
        {
            _beatLength -= .1;
            _gestureMessage.string = @"WAVE COMPLETE!";
            _gameStarted = FALSE;
            _gameCountdownMode = TRUE;
            _gameCountdown = 5;
            _timer.currentTime = 0;
        }
        
        if (_currentGestureSet == _fourSlap)
        {
            _currentGesture = _fourSlap[_currentGestureSetIndex];
            if ([_currentGesture isKindOfClass:[SingleSlap class]])
            {
                _currentGesture.typeOfSlapNeeded = @"SingleSlap";
            }
            if (!_gestureRecognized && _timer.currentTime >= 1* _beatLength)
            {
                _gestureMessage.string = @"SLAP!";
                //insert beat
            }
            if (!_gestureRecognized && _timer.currentTime >= 1.5*_beatLength)
            {
                _allowGesture = TRUE;
            }
            
            if (!_gestureRecognized && _gestureTimeStamp >= 2.2* _beatLength)
            {
                _gestureTimeStamp = .2*_beatLength;
                _timer.currentTime = .2*_beatLength;
                _currentGestureSetIndex++;
                _gestureRecognized = FALSE;
                _gestureMessage.string = @"TOO LATE!";
                [self setPercentage:-6];
                _allowGesture = FALSE;
                _currentNumOfBeats +=2;

            }
            else if (_gestureRecognized && _timer.currentTime >= 2*_beatLength)
            {
                _gestureTimeStamp = 0;
                _timer.currentTime = 0;
                _currentGestureSetIndex++;
                _gestureRecognized = FALSE;
                _allowGesture = FALSE;
                _currentNumOfBeats +=2;
            }
            
            if (_currentGestureSetIndex >= [_fourSlap count])
            {
                [self loadNewGesture];
            }
            
        }
        else if (_currentGestureSet == _threeSlapOneDouble)
        {
            _currentGesture = _threeSlapOneDouble[_currentGestureSetIndex];
            if ([_currentGesture isKindOfClass:[SingleSlap class]])
            {
                _currentGesture.typeOfSlapNeeded = @"SingleSlap";
                
                if (!_gestureRecognized && _timer.currentTime >= 1*_beatLength)
                {
                    _gestureMessage.string = @"SLAP!";
                }
                if (!_gestureRecognized && _timer.currentTime >= 1.5*_beatLength)
                {
                    _allowGesture = TRUE;
                }
                
                if (!_gestureRecognized && _gestureTimeStamp >= 2.2* _beatLength)
                {
                    _gestureTimeStamp = .2*_beatLength;
                    _timer.currentTime = .2*_beatLength;
                    _currentGestureSetIndex++;
                    _gestureRecognized = FALSE;
                    _gestureMessage.string = @"TOO LATE!";
                    [self setPercentage:-6];
                    _allowGesture = FALSE;
                    _currentNumOfBeats +=2;
                    
                }
                else if (_gestureRecognized && _timer.currentTime >= 2*_beatLength)
                {
                    _gestureTimeStamp = 0;
                    _timer.currentTime = 0;
                    _currentGestureSetIndex++;
                    _gestureRecognized = FALSE;
                    _allowGesture = FALSE;
                    _currentNumOfBeats +=2;
                }
            }
        
            else if ([_currentGesture isKindOfClass:[DoubleSlap class]])
            {
                
                if (!_gestureRecognized && _timer.currentTime >= 1*_beatLength )
                {
                    _gestureMessage.string = @"DOUBLE SLAP!";
                }
                if (!_gestureRecognized && _timer.currentTime >= 1.5*_beatLength)
                {
                    _allowGesture = TRUE;
                    _currentGesture.typeOfSlapNeeded = @"Left";
                    
                }
                if (!_gestureRecognized && _timer.currentTime >= 2.2*_beatLength && _percentageAlreadySubtracted)
                {
                    _allowGesture = TRUE;
                    _gestureRecognized = FALSE;
                    _gestureMessage.string = @"LATE!";
                    [self setPercentage: -3];
                    _percentageAlreadySubtracted = TRUE;
                    _currentGesture.typeOfSlapNeeded = @"Right";
                }
                
                if (!_gestureRecognized && _gestureTimeStamp >= 2.7* _beatLength)
                {
                    _gestureTimeStamp = .7*_beatLength;
                    _timer.currentTime = .7*_beatLength;
                    _currentGestureSetIndex++;
                    _gestureRecognized = FALSE;
                    if ([_gestureMessage.string isEqual:@"LATE!"])
                    {
                        _gestureMessage.string = @"DOUBLE LATE!";
                    }
                    else
                    {
                        _gestureMessage.string = @"LATE!";
                    }
                    
                    [self setPercentage: -3];
                    _allowGesture = FALSE;
                    _currentNumOfBeats +=2;
                    _percentageAlreadySubtracted = FALSE;
                    
                }
                else if (_gestureRecognized && _timer.currentTime >= 2.5*_beatLength)
                {
                    _gestureTimeStamp = .5;
                    _timer.currentTime = .5;
                    _currentGestureSetIndex++;
                    _gestureRecognized = FALSE;
                    _allowGesture = FALSE;
                    _currentNumOfBeats +=2;
                    _percentageAlreadySubtracted = FALSE;
                }

            }
            
            if (_currentGestureSetIndex >= [_threeSlapOneDouble count])
            {
                [self loadNewGesture];
            }

        }
        else if (_currentGestureSet == _twoDoubleOneTriple)
        {
            _currentGesture = _twoDoubleOneTriple[_currentGestureSetIndex];
            if ([_currentGesture isKindOfClass:[DoubleSlap class]])
            {
                
                if (!_gestureRecognized && _timer.currentTime >= 1*_beatLength )
                {
                    _gestureMessage.string = @"DOUBLE SLAP!";
                }
                if (!_gestureRecognized && _timer.currentTime >= 1.5*_beatLength)
                {
                    _allowGesture = TRUE;
                    _currentGesture.typeOfSlapNeeded = @"Left";
                    
                }
                if (!_gestureRecognized && _timer.currentTime >= 2.2*_beatLength && _percentageAlreadySubtracted)
                {
                    _allowGesture = TRUE;
                    _gestureRecognized = FALSE;
                    _gestureMessage.string = @"LATE!";
                    [self setPercentage: -3];
                    _percentageAlreadySubtracted = TRUE;
                    _currentGesture.typeOfSlapNeeded = @"Right";
                }
                
                if (!_gestureRecognized && _gestureTimeStamp >= 2.7* _beatLength)
                {
                    _gestureTimeStamp = .7*_beatLength;
                    _timer.currentTime = .7*_beatLength;
                    _currentGestureSetIndex++;
                    _gestureRecognized = FALSE;
                    if ([_gestureMessage.string isEqual:@"LATE!"])
                    {
                        _gestureMessage.string = @"DOUBLE LATE!";
                    }
                    else
                    {
                        _gestureMessage.string = @"LATE!";
                    }
                    
                    [self setPercentage: -3];
                    _allowGesture = FALSE;
                    _currentNumOfBeats +=2;
                    _percentageAlreadySubtracted = FALSE;
                    
                }
                else if (_gestureRecognized && _timer.currentTime >= 2.5*_beatLength)
                {
                    _gestureTimeStamp = .5;
                    _timer.currentTime = .5;
                    _currentGestureSetIndex++;
                    _gestureRecognized = FALSE;
                    _allowGesture = FALSE;
                    _currentNumOfBeats +=2;
                    _percentageAlreadySubtracted = FALSE;
                }
                
            }
            
            if (_currentGestureSetIndex >= [_threeSlapOneDouble count])
            {
                [self loadNewGesture];
            }

        }
        else if (_currentGestureSet == _twoSlapOneDown)
        {
            
        }
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
        [self performSelector:@selector(endGame) withObject:nil afterDelay:2];
    }
}

-(void) swipeLeft
{
    if (!_gestureRecognized && _allowGesture)
    {
        if ([_currentGesture.typeOfSlapNeeded  isEqual: @"SingleSlap"] && [_currentGesture isKindOfClass:[SingleSlap class]])
        {
            if (_gestureTimeStamp <2.05*_beatLength && _gestureTimeStamp > 1.95*_beatLength)
            {
                _gestureMessage.string = @"PERFECT!";
                [self setPercentage: 6];
                
            }
            else if (_gestureTimeStamp < 2.10*_beatLength && _gestureTimeStamp > 1.9 *_beatLength)
            {
                _gestureMessage.string = @"GOOD";
                [self setPercentage: 4];
            }
            else if (_gestureTimeStamp < 2.2 *_beatLength && _gestureTimeStamp > 1.8 *_beatLength)
            {
                _gestureMessage.string = @"OK";
                [self setPercentage: 2];
            }
            else if (_gestureTimeStamp < 1.8*_beatLength)
            {
                _gestureMessage.string = @"TOO EARLY!";
                [self setPercentage: -6];
            }
        }
        else if ([_currentGesture.typeOfSlapNeeded isEqual: @"Left"] && [_currentGesture isKindOfClass:[DoubleSlap class]])
        {
            if (_gestureTimeStamp <2.05*_beatLength && _gestureTimeStamp > 1.95*_beatLength)
            {
                _gestureMessage.string = @"PERFECT!";
                [self setPercentage: 3];
                
            }
            else if (_gestureTimeStamp < 2.1*_beatLength && _gestureTimeStamp > 1.9 *_beatLength)
            {
                _gestureMessage.string = @"GOOD";
                [self setPercentage: 2];
            }
            else if (_gestureTimeStamp < 2.2 *_beatLength && _gestureTimeStamp > 1.8 *_beatLength)
            {
                _gestureMessage.string = @"OK";
                [self setPercentage: 1];
            }
            else if (_gestureTimeStamp < 1.8*_beatLength)
            {
                _gestureMessage.string = @"TOO EARLY!";
                [self setPercentage: -3];
            }
        }
        else
        {
            _gestureMessage.string = @"WRONG SLAP";
            [self setPercentage: -6];
        }
            
        _gestureRecognized = TRUE;
        _allowGesture = FALSE;
    }
}

-(void) swipeRight
{
    if (!_gestureRecognized && _allowGesture)
    {
        if ([_currentGesture.typeOfSlapNeeded  isEqual: @"SingleSlap"] && [_currentGesture isKindOfClass:[SingleSlap class]])
        {
            if (_gestureTimeStamp <2.05*_beatLength && _gestureTimeStamp > 1.95*_beatLength)
            {
                _gestureMessage.string = @"PERFECT!";
                [self setPercentage: 6];
                
            }
            else if (_gestureTimeStamp < 2.10*_beatLength && _gestureTimeStamp > 1.9 *_beatLength)
            {
                _gestureMessage.string = @"GOOD";
                [self setPercentage: 4];
            }
            else if (_gestureTimeStamp < 2.2 *_beatLength && _gestureTimeStamp > 1.8 *_beatLength)
            {
                _gestureMessage.string = @"OK";
                [self setPercentage: 2];
            }
            else if (_gestureTimeStamp < 1.8*_beatLength)
            {
                _gestureMessage.string = @"TOO EARLY!";
                [self setPercentage: -6];
            }
        }
        
        else if ([_currentGesture.typeOfSlapNeeded isEqual: @"Right"] && [_currentGesture isKindOfClass:[DoubleSlap class]])
        {
            if (_gestureTimeStamp <2.55*_beatLength && _gestureTimeStamp > 2.45*_beatLength)
            {
                if ([_gestureMessage.string isEqual: @"PERFECT!"])
                {
                    _gestureMessage.string = @"DOUBLE PERFECT!";
                }
                else
                {
                   _gestureMessage.string = @"PERFECT!";
                }
                
                [self setPercentage: 3];
                
            }
            else if (_gestureTimeStamp < 2.6*_beatLength && _gestureTimeStamp > 2.4 *_beatLength)
            {
                _gestureMessage.string = @"GOOD";
                [self setPercentage: 2];
            }
            else if (_gestureTimeStamp < 2.7 *_beatLength && _gestureTimeStamp > 2.3 *_beatLength)
            {
                _gestureMessage.string = @"OK";
                [self setPercentage: 1];
            }
            else if (_gestureTimeStamp < 2.3*_beatLength)
            {
                _gestureMessage.string = @"TOO EARLY!";
                [self setPercentage: -3];
            }
        }
        else
        {
            _gestureMessage.string = @"WRONG SLAP";
            [self setPercentage: -6];
        }
        
        _gestureRecognized = TRUE;
        _allowGesture = FALSE;
    }
}

-(void) swipeUp
{
    
}

-(void) swipeDown
{
    
}

-(void) startGame
{
    _gameCountdownMode = FALSE;
    _gameStarted = TRUE;
    _allowGesture = FALSE;
    _currentGestureSet = [_queue objectAtIndex:0];
    _timer.currentTime = 0;
    _gestureTimeStamp = 0;
    _currentNumOfBeats = 0;
    _waveNumOfBeats = 32;
}

-(void) endGame
{
    
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


@end
