//
//  ComboBar.m
//  RhythmSlapObjc
//
//  Created by Brian Wang on 9/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "ComboBar.h"

@implementation ComboBar
{
    CCParticleSystem *_comboBarParticle;
    CCParticleSystem *_comboBarParticle2;

}

-(void) didLoadFromCCB
{
    self.totalSize = 100;
    self.currentSize = 50;
    _comboBarParticle = [CCBReader load: @"Particles/ComboBarParticle"];
    _comboBarParticle2 = [CCBReader load: @"Particles/ComboBarParticle"];
    
}

-(void) update:(CCTime)delta
{
    self.comboSize.contentSize = CGSizeMake(self.currentSize/self.totalSize, self.comboSize.contentSize.height);
    
    if (self.currentSize <= 33)
    {
        self.comboSize.color = [CCColor redColor];
    }
    else
    {
        self.comboSize.color = [CCColor cyanColor];
    }
}

-(void)loadParticleExplosionWithColor: (CCColor*) color
{
    CCParticleSystem *explosion = _comboBarParticle;
    [explosion removeFromParent];
    [explosion resetSystem];
    explosion.autoRemoveOnFinish = TRUE;
    explosion.position = ccp(_comboSize.contentSizeInPoints.width, _comboSize.contentSizeInPoints.height/2);
    explosion.startColor = color;
    explosion.endColor = color;
    [self.comboSize addChild: explosion];
    
    CCParticleSystem *explosion2 = _comboBarParticle2;
    [explosion2 removeFromParent];
    [explosion2 resetSystem];
    explosion2.autoRemoveOnFinish = TRUE;
    explosion2.position = ccp(0, _comboSize.contentSizeInPoints.height/2);
    explosion2.startColor = color;
    explosion2.endColor = color;
    [self.comboSize addChild: explosion2];
}
@end
