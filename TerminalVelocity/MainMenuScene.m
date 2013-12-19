//
//  MainMenuScene.m
//  TerminalVelocity
//
//  Created by Aaron Jones on 7/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenuScene.h"

@implementation MainMenuScene

- (void)dealloc {
    [mainMenuLayer release];
    [super dealloc];
}
-(id)init {
    self = [super init];
    if (self != nil) {
        mainMenuLayer = [[MainMenuLayer node] retain];
        [self addChild:mainMenuLayer];
    }
    return self;
}
@end
