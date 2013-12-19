//
//  Bird.h
//  TerminalVelocity
//
//  Created by Aaron Jones on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Box2DSprite.h"
#define WAIT_TIME_RELOAD 24

@interface Reload : Box2DSprite {
    CCAnimation *flyingAnim;
}
@property(nonatomic, retain) CCAnimation *flyingAnim;
@end
