//
//  AlienShip.h
//  TerminalVelocity
//
//  Created by Aaron Jones on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Box2DSprite.h"

#define WAIT_TIME_UMBRELLA 3

@interface Umbrella : Box2DSprite {
    CCAnimation *flyingAnim;
    CCAnimation *crashAnim;
    //float randFlight;
    int maxUmbrella;
}
@property(nonatomic, retain) CCAnimation *flyingAnim;
@property(nonatomic, retain) CCAnimation *crashAnim;

-(void)animateCollision;
-(void)startFlyingAnim;
@end
