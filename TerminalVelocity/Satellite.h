//
//  AlienShip.h
//  TerminalVelocity
//
//  Created by Aaron Jones on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Box2DSprite.h"

#define WAIT_TIME_SAT 24

@interface Satellite : Box2DSprite {
    CCAnimation *flyingAnim;
    CCAnimation *crashAnim;
    int maxSatilite;
    //float randFlight;
    //int maxAliens;
}
@property(nonatomic, retain) CCAnimation *flyingAnim;
@property(nonatomic, retain) CCAnimation *crashAnim;

-(void)animateCollision;
-(void)startFlyingAnim;

@end
