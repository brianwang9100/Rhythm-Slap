//
//  BeatBorder.m
//  RhythmSlapObjc
//
//  Created by Brian Wang on 11/19/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "BeatBorder.h"

@implementation BeatBorder

-(void) beat
{
    CCActionScaleTo *scaleIn = [CCActionScaleTo actionWithDuration:(double)_beatLength/2 scale:.985];
    CCActionEaseOut *popIn = [CCActionEaseOut actionWithAction:scaleIn rate:10];
    CCActionScaleTo *scaleOut = [CCActionScaleTo actionWithDuration:(double)_beatLength/2 scale: 1.1];
    CCActionEaseIn *popOut = [CCActionEaseIn actionWithAction:scaleOut rate:10];
    [self stopAllActions];
    [self runAction: [CCActionSequence actions: popIn, popOut, nil]];
}
-(void) changeColor:(CCColor*) color {
    [_topBorder setColor:color];
    [_leftBorder setColor:color];
    [_rightBorder setColor:color];
    [_bottomBorder setColor:color];
}
@end
