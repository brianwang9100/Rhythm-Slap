//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene

Hand *_hand;
Face *_face;
Timer *_timer;
ComboBar *_comboBar;
CCNodeGradient *_colorGradientNode;
CCNodeColor *_glowNode;
CCLabelTTF *_gestureMessage;

int _currentNumOfSlaps;
int _waveNumOfSlaps;

BOOL _gameCountdownMode;
int _gameCountdown;

BOOL _gameStarted;
BOOL _gameEnded;
BOOL _tutorialMode;
BOOL _comboMode;

NSArray *_fourSlap;
NSArray *_threeSlapOneDouble;
NSArray *_twoDoubleTwoSlap;
NSArray *_twoSlapOneDown;

NSMutableArray *_queue;

int _comboBarSize;

NSArray *_currentGestureSet;
int _currentGestureSetIndex;
int _totalPoints;

UISwipeGestureRecognizer *_swipeLeft;
UISwipeGestureRecognizer *_swipeRight;
UISwipeGestureRecognizer *_swipeUp;
UISwipeGestureRecognizer *_swipeDown;

-(void) didLoadFromCCB
{
    self.userInteractionEnabled = FALSE;
    _gestureMessage.string = @"";
    
    
    _currentNumOfSlaps = 0;
    _waveNumOfSlaps = 12;
    
    _gameCountdownMode = TRUE;
    _gameCountdown = 5;
    _gameStarted = FALSE;
    _gameEnded = FALSE;
    _comboMode = FALSE;
    
    _currentGestureSet = nil;
    _currentGestureSetIndex = 0;
    _totalPoints = 0;
    
    

    _fourSlap = [NSArray arrayWithObjects: [SingleSlap init],[SingleSlap init], [SingleSlap init], [SingleSlap init], nil];
    _threeSlapOneDouble = [NSArray arrayWithObjects: [SingleSlap init],[SingleSlap init], [SingleSlap init], [DoubleSlap init], nil];
    _twoDoubleTwoSlap = [NSArray arrayWithObjects: [DoubleSlap init],[DoubleSlap init], [SingleSlap init], [SingleSlap init], nil];
    _twoSlapOneDown = [NSArray arrayWithObjects: [SingleSlap init],[SingleSlap init], [SlapDown init], nil];
    
    _queue = [NSMutableArray arrayWithObjects: _fourSlap, _threeSlapOneDouble, _fourSlap, _twoSlapOneDown,  nil];
    
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
    if (!_gameStarted)
    {
        if (_gameCountdownMode)
        {
            if (_timer.currentTime >= 1)
            {
                if (_gameCountdown == 0)
                {
                    _gestureMessage.string = @"START!";
                    [self startGame];
                }
                else if (_gameCountdown < 4)
                {
                    _gestureMessage.string = [NSString stringWithFormat:@"%i", _gameCountdown];
                }
                _timer.currentTime = 0;
            }
        }
    }
    else if (!_gameEnded)
    {
        if (_currentGestureSet == _fourSlap)
        {
            
        }
        else if ( _currentGestureSet == _threeSlapOneDouble)
        {
            
        }
        else if (_currentGestureSet == _twoDoubleTwoSlap)
        {
            
        }
        else if (_currentGestureSet == _twoSlapOneDown)
        {
            
        }
    }
}

-(void) setPercentage: (int) percent
{
    _comboBarSize += percent;
    
    if (_comboBarSize > 100)
    {
        _comboBarSize = 100;
        _comboMode = TRUE;
    }
    else
    {
        _comboMode = FALSE;
    }
}

-(void) startGame
{
    _gameCountdownMode = FALSE;
    _gameStarted = TRUE;
    self.userInteractionEnabled = TRUE;
    _currentGestureSet = [_queue objectAtIndex:0];
    _timer.currentTime = 0;
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
        case 2: generatedGesture = _twoDoubleTwoSlap;
            break;
        case 3: generatedGesture = _twoSlapOneDown;
            break;
    }
    [_queue addObject: generatedGesture];
}


@end
