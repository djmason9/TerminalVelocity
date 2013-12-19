//
//  AlienShip.h
//  TerminalVelocity
//
//  Created by Aaron Jones on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Box2DSprite.h"

#define WAIT_TIME_ALIEN 5

@interface AlienShip : Box2DSprite {
    CCAnimation *flyingAnim;
    CCAnimation *crashAnim;
    //float randFlight;
    //float randFlightTime;
    int maxAliens;
}
@property(nonatomic, retain) CCAnimation *flyingAnim;
@property(nonatomic, retain) CCAnimation *crashAnim;

-(void)animateCollision;
-(void)startFlyingAnim;
@end
