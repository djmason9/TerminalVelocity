//
//  CloudBackgroundLayer.h
//  TerminalVelocity
//
//  Created by Aaron Jones on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#define boris_random(smallNumber, bigNumber) ((((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * (bigNumber - smallNumber)) + smallNumber)

#import <Foundation/Foundation.h>
#import "BackgroundLayer.h"
#import "SimpleAudioEngine.h"
#import "GameMusicManager.h"
#import "SkyCloudsLayer.h"

@interface SkyBackgroundLayer : BackgroundLayer {
    SkyCloudsLayer *cloudsLayer;
    CCSprite *cityFront;
    CCNode *backgroundImage;
}

@end
