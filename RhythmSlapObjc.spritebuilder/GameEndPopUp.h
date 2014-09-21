//
//  GameEndPopUp.h
//  RhythmSlapObjc
//
//  Created by Brian Wang on 9/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface GameEndPopUp : CCNode
@property (strong, nonatomic) CCNodeColor *gameOverColor;
@property (strong, nonatomic) CCLabelTTF *gameOverText;
@property (strong, nonatomic) CCLabelTTF *yourScoreTitle;
@property (strong, nonatomic) CCLabelTTF *yourScoreNum;
@property (strong, nonatomic) CCLabelTTF *highScoreTitle;
@property (strong, nonatomic) CCLabelTTF *highScoreNum;
@property (strong, nonatomic) CCButton *tryAgain;
@property (strong, nonatomic) CCButton *mainMenu;
@end
