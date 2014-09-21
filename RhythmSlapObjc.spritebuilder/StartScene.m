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
    
    UISwipeGestureRecognizer *_swipeLeft;
    UISwipeGestureRecognizer *_swipeRight;
    UISwipeGestureRecognizer *_swipeUp;
    UISwipeGestureRecognizer *_swipeDown;
}

-(void) didLoadFromCCB
{
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
    //animate face
    _face.faceSprite.spriteFrame = [CCSpriteFrame frameWithImageNamed:(@"Sprites/Face/face_left.png")];
    [self performSelector:@selector(startGame) withObject:nil afterDelay:2];
    
}

-(void) swipeRight
{
    //animate face
    _face.faceSprite.spriteFrame = [CCSpriteFrame frameWithImageNamed:(@"Sprites/Face/face_left.png")];
    _face.faceSprite.flipX = TRUE;
    [self performSelector:@selector(startGame) withObject:nil afterDelay:2];
}

-(void) swipeUp
{
    //animate face
    _face.faceSprite.spriteFrame = [CCSpriteFrame frameWithImageNamed:(@"Sprites/Face/face_uppercut.png")];
    [self performSelector:@selector(startGame) withObject:nil afterDelay:2];
}

-(void) swipeDown
{
    //animate face
    _face.faceSprite.spriteFrame = [CCSpriteFrame frameWithImageNamed:(@"Sprites/Face/face_headbash.png")];
    [self performSelector:@selector(startGame) withObject:nil afterDelay:2];
}

-(void) startGame
{
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene: mainScene];
}
@end
