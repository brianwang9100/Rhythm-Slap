//
//  StartScene.h
//  RhythmSlapObjc
//
//  Created by Brian Wang on 9/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCScene.h"
#import "Hand.h"
#import "Face.h"

@interface StartScene : CCScene

-(void) hitLeft;
-(void) hitRight;
-(void) hitUp;
-(void) hitDown;

@end
