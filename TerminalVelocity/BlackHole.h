//
//  BlackHole.h
//  TerminalVelocity
//
//  Created by Darren Mason on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Box2DSprite.h"


@interface BlackHole : Box2DSprite{
    CCAnimation *dyingAnim;
}

@property(nonatomic, retain) CCAnimation *dyingAnim;

-(void)animateCollision;

@end
