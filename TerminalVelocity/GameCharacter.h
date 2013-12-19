//
//  GameCharacter.h
//  TerminalVelocity
//
//  Created by Aaron Jones on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameObject.h"
#import "GameScene.h"

@interface GameCharacter : GameObject {
    float velocity;
    
}

-(void)checkAndClampSpritePosition; 
-(int)getDamage;


@property float velocity;
@end
