//
//  Box2DSprite.h
//  TerminalVelocity
//
//  Created by Aaron Jones on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameCharacter.h"
#import "Constants.h"
#import "Box2D.h"
#import "Box2DHelpers.h"
#import "GameManager.h"


@interface Box2DSprite : GameCharacter {
    b2Body *body;
    float waitTime;
    float time;
    float randFlight;
    float randFlightTime;
    int lastRand;
    bool lastSign;
}

@property(assign) b2Body *body;

// Return TRUE to accept the mouse joint
// Return FALSE to reject the mouse joint
-(BOOL)mouseJointBegan;
-(id)initWithWorld:(b2World *)world atLocation:(CGPoint)location;
-(id)initRandomInWorld:(b2World *)world;
-(void)resetObject;
-(void)startObject;
-(void)setRandomPath;
@end
