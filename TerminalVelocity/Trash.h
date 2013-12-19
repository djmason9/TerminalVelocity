//
//  AlienShip.h
//  TerminalVelocity
//
//  Created by Aaron Jones on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Box2DSprite.h"

@interface Trash : Box2DSprite {
    CCAnimation *flyingAnim;
    CCAnimation *crashAnim;
    int maxTrash;

}
@property(nonatomic, retain) CCAnimation *flyingAnim;
@property(nonatomic, retain) CCAnimation *crashAnim;

-(void)animateCollision;

@end
