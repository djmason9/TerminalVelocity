//
//  AlienShip.h
//  TerminalVelocity
//
//  Created by Aaron Jones on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Box2DSprite.h"
// old value 36
#define WAIT_TIME_FIREWORK 36

@interface Firework : Box2DSprite {
    CCAnimation *flyingAnim;
    CCAnimation *crashAnim;
    //float randFlight;
    
}
@property(nonatomic, retain) CCAnimation *flyingAnim;
@property(nonatomic, retain) CCAnimation *crashAnim;

-(void)animateCollision;
-(void)startFlyingAnim;
@end
