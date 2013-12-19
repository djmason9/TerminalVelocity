//
//  Bird.h
//  TerminalVelocity
//
//  Created by Aaron Jones on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Box2DSprite.h"
#define WAIT_TIME_LIGHTNING 36

@interface Lightning : Box2DSprite {
    CCAnimation *flyingAnim;
}
@property(nonatomic, retain) CCAnimation *flyingAnim;

-(void)animateCollision;
@end
