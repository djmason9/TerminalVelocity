//
//  AlienShip.h
//  TerminalVelocity
//
//  Created by Aaron Jones on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Box2DSprite.h"

#define WAIT_TIME_BLIMP 10

@interface Blimp : Box2DSprite {
    CCAnimation *flyingAnim;
    //float randFlight;
    int maxBlimps;
}
@property(nonatomic, retain) CCAnimation *flyingAnim;

-(void)animateCollision;
-(void)startFlyingAnim;
@end
