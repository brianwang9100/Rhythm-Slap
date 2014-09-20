//
//  Timer.h
//  RhythmSlapObjc
//
//  Created by Brian Wang on 9/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface Timer : CCNode
@property (assign, nonatomic) float currentTime;
@property (assign, nonatomic) float beatLength;
@end
