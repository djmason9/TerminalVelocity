//
//  Bird.h
//  TerminalVelocity
//
//  Created by Aaron Jones on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Box2DSprite.h"
//#define WAIT_TIME_BIRD 2

@interface Bird : Box2DSprite {
    CCAnimation *flyingAnim;
    //float randFlight;
    //float randFlightTime;
}
@property(nonatomic, retain) CCAnimation *flyingAnim;
@end