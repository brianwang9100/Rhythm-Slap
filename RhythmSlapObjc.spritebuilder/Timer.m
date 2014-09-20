//
//  Timer.m
//  RhythmSlapObjc
//
//  Created by Brian Wang on 9/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Timer.h"

@implementation Timer

-(void) didLoadFromCCB
{
    self.currentTime = 0.0;
}

-(void) update:(CCTime)delta
{
    self.currentTime += delta;
}

@end
