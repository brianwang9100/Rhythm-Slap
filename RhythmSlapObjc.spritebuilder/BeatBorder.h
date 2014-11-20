//
//  BeatBorder.h
//  RhythmSlapObjc
//
//  Created by Brian Wang on 11/19/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface BeatBorder : CCNode
@property (strong, nonatomic) CCNode *borderContainerNode;
@property (strong, nonatomic) CCNode *topBorder;
@property (strong, nonatomic) CCNode *leftBorder;
@property (strong, nonatomic) CCNode *rightBorder;
@property (strong, nonatomic) CCNode *bottomBorder;
@property (assign, nonatomic) float beatLength;
-(void) beat;
@end
