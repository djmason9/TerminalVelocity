//
//  AlienShip.h
//  TerminalVelocity
//
//  Created by Aaron Jones on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Box2DSprite.h"

#define WAIT_TIME_GARGOYLE 24

@class GameManager;

@interface Gargoyle : Box2DSprite {
    GameManager *gameManager;
}

-(void)animateCollision;

@end
