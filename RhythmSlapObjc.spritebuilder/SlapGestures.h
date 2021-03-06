//
//  SlapGestures.h
//  RhythmSlapObjc
//
//  Created by Brian Wang on 9/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface SlapGestures : CCNode
@property (strong, nonatomic) NSString *typeOfSlapNeeded;
@property (assign, nonatomic) float timeStamp;
-(id) initWithTime: (float) givenTimeStamp andType: (NSString*) type;
@end
