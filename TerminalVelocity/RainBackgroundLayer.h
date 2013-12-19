//
//  RainBackgroundLayer.h
//  TerminalVelocity
//
//  Created by Aaron Jones on 9/3/11.
//  Copyright (c) 2011 Dark Energy Studios. All rights reserved.
//

#import "SkyBackgroundLayer.h"

// old value 120
//#define TRANSTION_TIME 5

@interface RainBackgroundLayer : SkyBackgroundLayer {
    CCSprite *rainBackgroundImage1;
    CCSprite *rainBackgroundImage2;
    
    CCSprite *lighning1;
    CCSprite *lighning2;
    CCSprite *lighning3;
    CCSprite *lighning4;
    
    float lighningTime;
}

@end
