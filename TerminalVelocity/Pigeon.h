//
//  Pigeon.h
//  TerminalVelocity
//
//  Created by Darren Mason on 9/2/11.
//  Copyright (c) 2011 Dark Energy Studios. All rights reserved.
//

#import "Box2DSprite.h"

@interface Pigeon : Box2DSprite {
    CCAnimation *flyingAnim;
}
@property(nonatomic, retain) CCAnimation *flyingAnim;
@end
