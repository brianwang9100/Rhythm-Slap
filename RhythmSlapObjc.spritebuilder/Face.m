//
//  Face.m
//  RhythmSlapObjc
//
//  Created by Brian Wang on 9/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Face.h"

@implementation Face

-(void) didLoadFromCCB
{
    
}

-(void) update:(CCTime)delta
{
    
}

-(void) hitLeft
{
    self.faceSprite.spriteFrame = [CCSpriteFrame frameWithImageNamed: @"Sprites/Face/face_left.png"];
    self.faceSprite.flipX = FALSE;
}

-(void) hitRight
{
    self.faceSprite.spriteFrame = [CCSpriteFrame frameWithImageNamed: @"Sprites/Face/face_left.png"];
    self.faceSprite.flipX = TRUE;
}

-(void) hitUp
{
    self.faceSprite.spriteFrame = [CCSpriteFrame frameWithImageNamed: @"Sprites/Face/face_uppercut.png"];
}

-(void) hitDown
{
    self.faceSprite.spriteFrame = [CCSpriteFrame frameWithImageNamed: @"Sprites/Face/face_headbash.png"];
}

-(void) reset
{
    self.faceSprite.spriteFrame = [CCSpriteFrame frameWithImageNamed: @"Sprites/Face/face_normal.png"];
}
@end
