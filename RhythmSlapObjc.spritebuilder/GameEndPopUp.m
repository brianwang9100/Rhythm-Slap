//
//  GameEndPopUp.m
//  RhythmSlapObjc
//
//  Created by Brian Wang on 9/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameEndPopUp.h"

@implementation GameEndPopUp
{
    CCNodeColor *_gameOverColor;
    CCLabelTTF *_gameOverText;
    CCLabelTTF *_yourScoreTitle;
    CCLabelTTF *_yourScoreNum;
    CCLabelTTF *_highScoreTitle;
    CCLabelTTF *_highScoreNum;
}

-(void) retry
{
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene: mainScene];
}

-(void) mainMenu
{
    CCScene *startScene = [CCBReader loadAsScene:@"StartScene"];
    [[CCDirector sharedDirector] replaceScene: startScene];
}
@end
