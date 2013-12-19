//
//  ClearBackgroundLayer.h
//  TerminalVelocity
//
//  Created by Aaron Jones on 9/3/11.
//  Copyright (c) 2011 Dark Energy Studios. All rights reserved.
//

#import "SkyBackgroundLayer.h"

// old value 90
//#define TRANSTION_TIME 5


@interface DayBackgroundLayer : SkyBackgroundLayer {
    CCSprite *skyInTransision;
    CCSprite *sun;
}

@end
