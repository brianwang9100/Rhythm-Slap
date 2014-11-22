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
}

-(void) didLoadFromCCB
{
    self.totalSize = 100;
    self.currentSize = 50;
    _comboBarParticle = [CCBReader load: @"Particles/ComboBarParticle"];
    
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
}
@end
