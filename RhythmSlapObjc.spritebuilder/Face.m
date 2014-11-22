//
//  Face.m
//  RhythmSlapObjc
//
//  Created by Brian Wang on 9/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Face.h"

@implementation Face {
    CCSpriteFrame *_left;
    CCSpriteFrame *_right;
    CCSpriteFrame *_up;
    CCSpriteFrame *_down;
    CCSpriteFrame *_normal;
    
    CCParticleSystem *_leftSpit;
    CCParticleSystem *_rightSpit;
    CCParticleSystem *_starsParticle;
}

-(void) didLoadFromCCB
{
    _left = [CCSpriteFrame frameWithImageNamed: @"Sprites/Face/face_left.png"];
    _right = [CCSpriteFrame frameWithImageNamed: @"Sprites/Face/face_left.png"];
    _up = [CCSpriteFrame frameWithImageNamed: @"Sprites/Face/face_uppercut.png"];
    _down = [CCSpriteFrame frameWithImageNamed: @"Sprites/Face/face_headbash.png"];
    _normal = [CCSpriteFrame frameWithImageNamed: @"Sprites/Face/face_normal.png"];
    
    _leftSpit = [CCBReader load: @"Particles/SpitParticleLeft"];
    _rightSpit = [CCBReader load: @"Particles/SpitParticleRight"];
    _starsParticle = [CCBReader load: @"Particles/StarsParticle"];
}

-(void) update:(CCTime)delta
{
    
}

-(void) hitLeft
{
    [self loadParticleExplosionWithDirection:@"Left"];
    self.faceSprite.spriteFrame = _left;
    self.faceSprite.flipX = FALSE;
}

-(void) hitRight
{
    [self loadParticleExplosionWithDirection:@"Right"];
    self.faceSprite.spriteFrame = _right;
    self.faceSprite.flipX = TRUE;
}

-(void) hitUp
{
    [self loadStarsParticleExplosion];
    self.faceSprite.spriteFrame = _up;
}

-(void) hitDown
{
    [self loadStarsParticleExplosion];
    self.faceSprite.spriteFrame = _down;
}

-(void) reset
{
    self.faceSprite.spriteFrame = _normal;
}

-(void)loadParticleExplosionWithDirection: (NSString*) direction
{
    CCParticleSystem *explosion;
    if ([direction isEqualToString: @"Left"])
    {
        explosion = _leftSpit;
    }
    else if ([direction isEqualToString: @"Right"])
    {
        explosion = _rightSpit;
    }
    [explosion removeFromParent];
    [explosion resetSystem];
    explosion.autoRemoveOnFinish = TRUE;
    explosion.position = self.position;
    [self addChild: explosion];
}

-(void)loadStarsParticleExplosion
{
    CCParticleSystem *explosion = _starsParticle;
    [explosion removeFromParent];
    [explosion resetSystem];
    explosion.autoRemoveOnFinish = TRUE;
    explosion.position = self.position;
    [self addChild: explosion];
}
@end
