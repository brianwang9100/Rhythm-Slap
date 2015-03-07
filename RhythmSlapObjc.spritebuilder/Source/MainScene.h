//
//  MainScene.h
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "CCScene.h"
#import "Hand.h"
#import "Face.h"
#import "ComboBar.h"
#import "GameEndPopUp.h"
#import "Timer.h"
#import "SlapGestures.h"
#import "BeatBorder.h"
#import "SoundDelegate.h"

@interface MainScene : CCScene
@property (strong, nonatomic) SoundDelegate* soundDelegate;
@end
