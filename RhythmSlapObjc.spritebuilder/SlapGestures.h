//
//  SlapGestures.h
//  RhythmSlapObjc
//
//  Created by Brian Wang on 9/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface SlapGestures : CCNode
@property (assign, nonatomic) int numOfBeats;
@property (weak, nonatomic) NSMutableArray *slapSequence;
@property (weak, nonatomic) NSMutableArray *slapSequenceTimeStamp;

@end
