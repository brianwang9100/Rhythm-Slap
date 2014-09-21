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
    [self loadParticleExplosionWithParticleName:@"Spit" onObject:self withDirection:@"Left"];
    self.faceSprite.spriteFrame = [CCSpriteFrame frameWithImageNamed: @"Sprites/Face/face_left.png"];
    self.faceSprite.flipX = FALSE;
}

-(void) hitRight
{
    [self loadParticleExplosionWithParticleName:@"Spit" onObject:self withDirection:@"Right"];
    self.faceSprite.spriteFrame = [CCSpriteFrame frameWithImageNamed: @"Sprites/Face/face_left.png"];
    self.faceSprite.flipX = TRUE;
}

-(void) hitUp
{
    [self loadParticleExplosionWithParticleName:@"Stars" onObject:self];
    self.faceSprite.spriteFrame = [CCSpriteFrame frameWithImageNamed: @"Sprites/Face/face_uppercut.png"];
}

-(void) hitDown
{
    [self loadParticleExplosionWithParticleName:@"Stars" onObject:self];
    self.faceSprite.spriteFrame = [CCSpriteFrame frameWithImageNamed: @"Sprites/Face/face_headbash.png"];
}

-(void) reset
{
    self.faceSprite.spriteFrame = [CCSpriteFrame frameWithImageNamed: @"Sprites/Face/face_normal.png"];
}

-(void)loadParticleExplosionWithParticleName: (NSString *) particleName onObject: (CCNode*) object withDirection: (NSString*) direction
{
    @synchronized(self)
    {
        CCParticleSystem *explosion = (CCParticleSystem*)[CCBReader load: [NSString stringWithFormat:@"Particles/%@Particle%@", particleName, direction]];
        explosion.autoRemoveOnFinish = TRUE;
        explosion.position = object.position;
        [self addChild: explosion];
    }
}

-(void)loadParticleExplosionWithParticleName: (NSString *) particleName onObject: (CCNode*) object
{
    @synchronized(self)
    {
        CCParticleSystem *explosion = (CCParticleSystem*)[CCBReader load: [NSString stringWithFormat:@"Particles/%@Particle", particleName]];
        explosion.autoRemoveOnFinish = TRUE;
        explosion.position = object.position;
        [self addChild: explosion];
    }
}
@end
