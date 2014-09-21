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
    self.currentSize = 10;
}

-(void) update:(CCTime)delta
{
    self.comboSize.contentSize = CGSizeMake(self.currentSize/self.totalSize, self.comboSize.contentSize.height);
    
    if (self.currentSize <= 33)
    {
        self.comboSize.color = [CCColor redColor];
    }
    else
    {
        self.comboSize.color = [CCColor cyanColor];
    }

}
@end
