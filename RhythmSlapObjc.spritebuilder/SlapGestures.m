//
//  SlapGestures.m
//  RhythmSlapObjc
//
//  Created by Brian Wang on 9/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "SlapGestures.h"

@implementation SlapGestures

-(id) initWithTime: (float) givenTimeStamp andType: (NSString*) type
{
    self.timeStamp = givenTimeStamp;
    self.typeOfSlapNeeded = type;
    return self;
}

@end
