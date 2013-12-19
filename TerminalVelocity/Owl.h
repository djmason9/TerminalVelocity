//
//  Owl.h
//  TerminalVelocity
//
//  Created by Darren Mason on 9/2/11.
//  Copyright (c) 2011 Dark Energy Studios. All rights reserved.
//

#import "Box2DSprite.h"
#define WAIT_TIME_OWL 24

@interface Owl : Box2DSprite {
    CCAnimation *flyingAnim;
    int maxOwls;
    //float randFlight;
    //float randFlightTime;
}
@property(nonatomic, retain) CCAnimation *flyingAnim;
@end
