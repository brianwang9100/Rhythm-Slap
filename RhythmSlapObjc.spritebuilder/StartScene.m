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
}

-(void) swipeLeft
{
    [_face hitLeft];
    [self removeBars];
    [self performSelector:@selector(startGame) withObject:nil afterDelay:2];
    
}

-(void) swipeRight
{
    //animate face
    [_face hitRight];
    [self removeBars];
    [self performSelector:@selector(startGame) withObject:nil afterDelay:2];
}

-(void) swipeUp
{
    //animate face
    [_face hitUp];
    [self removeBars];
    [self performSelector:@selector(startGame) withObject:nil afterDelay:2];
}

-(void) swipeDown
{
    //animate face
    [_face hitDown];
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
