//
//  CityBackgroundLayer.h
//  TerminalVelocity
//
//  Created by Aaron Jones on 9/3/11.
//  Copyright (c) 2011 Dark Energy Studios. All rights reserved.
//

#import "BackgroundLayer.h"

//old value 65
//#define TRANSTION_TIME 120

@interface CityBackgroundLayer : BackgroundLayer {
    CCSprite *backgroundImage;
    CCSprite *cityScape;
    CCSprite *sideWalls1;
    CCSprite *sideWalls2;
    CCSprite *sideWallsTop;
    CCSprite *crack;
    //CCSprite *manholeFront;
    CCSprite *brickWall;
    BOOL scrollBrickWall;
    
    CCLayer *gameplayLayer;
}
@property(nonatomic, retain) CCLayer *gameplayLayer;
@property(nonatomic, readwrite) BOOL scrollBrickWall;
@end
