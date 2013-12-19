//
//  SpaceBackgroundLayer.h
//  TerminalVelocity
//
//  Created by Aaron Jones on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BackgroundLayer.h"
#import "ButtonControl.h"

@interface SpaceBackgroundLayer : BackgroundLayer {
    CCSprite *movingStars1;
    CCSprite *movingStars2;
    CCSprite *moonImage;
    CCSprite *earthImage;
    BOOL isCentered;
    
    CCLayer *instructionsLayer;
}
@end
