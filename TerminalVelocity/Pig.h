//
//  AlienShip.h
//  TerminalVelocity
//
//  Created by Aaron Jones on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Box2DSprite.h"

#define WAIT_TIME_PIG 10

@interface Pig : Box2DSprite {
    CCAnimation *flyingAnim;
    //float randFlight;
    //float randFlightTime;
    //int maxAliens;
    int maxPig;
}
@property(nonatomic, retain) CCAnimation *flyingAnim;

-(void)animateCollision;
-(void)startFlyingAnim;
@end
