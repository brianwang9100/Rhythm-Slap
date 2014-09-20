//
//  ComboBar.m
//  RhythmSlapObjc
//
//  Created by Brian Wang on 9/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "ComboBar.h"

@implementation ComboBar

-(void) didLoadFromCCB
{
    self.totalSize = 100;
    self.currentSize = 70;
}

-(void) update:(CCTime)delta
{
    self.comboSize.contentSize = CGSizeMake((float)(self.currentSize/self.totalSize), self.comboSize.contentSize.height);
}
@end
