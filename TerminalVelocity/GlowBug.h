//
//  Bird.h
//  TerminalVelocity
//
//  Created by Aaron Jones on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Box2DSprite.h"
#define WAIT_TIME_GLOW_BUG 36

@interface GlowBug : Box2DSprite {
    CCAnimation *flyingAnim;
    //float randFlight;
}
@property(nonatomic, retain) CCAnimation *flyingAnim;
@end
