//
//  GameCharacter.m
//  TerminalVelocity
//
//  Created by Aaron Jones on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameCharacter.h"
#import "GameManager.h"

@implementation GameCharacter

@synthesize velocity;

-(void) dealloc { 
    [super dealloc];
}

-(int)getDamage {
    // Default to zero damage
    CCLOG(@"getWeaponDamage should be overriden");
    return 0;
}

-(void)checkAndClampSpritePosition {
    CGPoint currentSpritePosition = [self position];
    
    CGSize levelSize = [[GameManager sharedGameManager] getDimensionsOfCurrentScene];
    float xOffset;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // Clamp for the iPad
        xOffset = 30.0f;
    } else {
        // Clamp for iPhone, iPhone 4, or iPod touch
        xOffset = 24.0f;
    }
    
    if (currentSpritePosition.x < xOffset) {
        [self setPosition:ccp(xOffset, currentSpritePosition.y)];
    } else if (currentSpritePosition.x > (levelSize.width - xOffset)) {
        [self setPosition:ccp((levelSize.width - xOffset), currentSpritePosition.y)];
    }
}
/*
-(void)checkAndClampSpritePosition { 
    CGPoint currentSpritePosition = [self position];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // Clamp for the iPad
        if (currentSpritePosition.x < 30.0f) {
            [self setPosition:ccp(30.0f, currentSpritePosition.y)];
        } else if (currentSpritePosition.x > 1000.0f) {
            [self setPosition:ccp(1000.0f, currentSpritePosition.y)];
        } 
    } else {
        // Clamp for iPhone, iPhone 4, or iPod touch
        if (currentSpritePosition.x < 24.0f) {
            [self setPosition:ccp(24.0f, currentSpritePosition.y)];
        } else if (currentSpritePosition.x > 456.0f) {
            [self setPosition:ccp(456.0f, currentSpritePosition.y)];
        } 
    }
}*/

@end
