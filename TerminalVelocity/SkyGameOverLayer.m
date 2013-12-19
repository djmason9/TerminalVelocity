//
//  SkyGameOverLayer.m
//  TerminalVelocity
//
//  Created by Aaron Jones on 8/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SkyGameOverLayer.h"

@implementation SkyGameOverLayer
-(void)loadGameObjects {
    [super loadGameObjects];
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    CCSprite *background = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                                                            spriteFrameByName:@"deathscreen.png"]];
    background.position = ccp(screenSize.width/2, screenSize.height/2);
    [self addChild:background z:-1];
    
}
@end
