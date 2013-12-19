//
//  AlienShip.h
//  TerminalVelocity
//
//  Created by Aaron Jones on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Box2DSprite.h"

//#define WAIT_TIME_PLANE 10

@interface Plane : Box2DSprite {
    CCAnimation *flyingAnim;
    //float randFlight;
    int maxPlanes;
}
@property(nonatomic, retain) CCAnimation *flyingAnim;

-(void)animateCollision;
-(void)startFlyingAnim;
@end
