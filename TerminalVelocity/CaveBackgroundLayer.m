//
//  CaveBackgroundLayer.m
//  TerminalVelocity
//
//  Created by Aaron Jones on 9/8/11.
//  Copyright (c) 2011 Dark Energy Studios. All rights reserved.
//

#import "CaveBackgroundLayer.h"
#import "HUDLayer.h"
#import "GameManager.h"

@implementation CaveBackgroundLayer

- (void)dealloc {
    [backgroundImage1 release];
    [backgroundImage2 release];
    [caveWalls1 release];
    [caveWalls2 release];
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        CGFloat bg1 = -684;
        CGFloat bg2 = -1164;
        
        spriteBatchNode = [[CCSpriteBatchNode batchNodeWithFile:@"cave_items.png"] retain];
        [self addChild:spriteBatchNode];
        
        backgroundImage1 = [[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"cave_background.png"]] retain];
        backgroundImage1.position = ccp(screenSize.width/2, bg1); //-424, -474
        [spriteBatchNode addChild:backgroundImage1];
        
        backgroundImage2 = [[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"cave_background.png"]] retain];
        backgroundImage2.position = ccp(screenSize.width/2, bg2); //-904, -954
        [spriteBatchNode addChild:backgroundImage2];
        
        caveWalls1 = [[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"cave_walls.png"]] retain];
        caveWalls1.position = ccp(screenSize.width/2, bg1);
        [spriteBatchNode addChild:caveWalls1];
        
        caveWalls2 = [[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"cave_walls.png"]] retain];
        caveWalls2.position = ccp(screenSize.width/2, bg2);
        [spriteBatchNode addChild:caveWalls2];
    }
    return self;
}

-(void)updateScroll:(ccTime)deltaTime pos:(CGPoint)pos {
    transitionTime += deltaTime;
    
    if ([GameManager sharedGameManager].hasPlayerDied) {
        spriteBatchNode.visible = NO;
        self.visible = NO;
        return;
    }
    
    if(!isTransitioningOut && transitionTime > TRANSTION_TIME_CAVE){
        isTransitioningOut = YES;
        //[[GameManager sharedGameManager] transitionToSceneWithID:kCaveScene];
        
        //end game
        
    }
    
    if (isTransitioningOut) {
        
    }
    
    if (backgroundImage1.position.y < screenSize.height*0.5 && isTransitioning) {
        [transitionLayer updateScroll:deltaTime pos:pos];
        float rate = 2000.0f / pos.y;
        backgroundImage1.position = ccp(backgroundImage1.position.x, backgroundImage1.position.y + rate);
        backgroundImage2.position = ccp(backgroundImage2.position.x, backgroundImage2.position.y + rate);
        caveWalls1.position = ccp(caveWalls1.position.x, caveWalls1.position.y + rate);
        caveWalls2.position = ccp(caveWalls2.position.x, caveWalls2.position.y + rate);
        
    } else if (transitionLayer != nil) {
        HUDLayer *hud = (HUDLayer *)[self.parent getChildByTag:kSKY_HUD_LAYER_TAG];
        hud->actionButton.isTouchEnabled = YES;
        isTransitioning = NO;
        [transitionLayer removeFromParentAndCleanup:YES];
        [transitionLayer release];
        transitionLayer = nil;
    }
    
    if (pos.y > 0 && !isTransitioning) {
        float rate = 2000.0f / pos.y;
        backgroundImage1.position = ccp(backgroundImage1.position.x, backgroundImage1.position.y + (rate*0.5));
        backgroundImage2.position = ccp(backgroundImage2.position.x, backgroundImage2.position.y + (rate*0.5));
        caveWalls1.position = ccp(caveWalls1.position.x, caveWalls1.position.y + rate);
        caveWalls2.position = ccp(caveWalls2.position.x, caveWalls2.position.y + rate);
    }
    
    if (backgroundImage1.position.y  > 720) {
        [backgroundImage1 setPosition:ccp(backgroundImage2.position.x, backgroundImage2.position.y - screenSize.height)];
    }
    if (backgroundImage2.position.y  > 720) {
        [backgroundImage2 setPosition:ccp(backgroundImage1.position.x, backgroundImage1.position.y - screenSize.height)];
    }
    
    
    if (caveWalls1.position.y  > 720) {
        [caveWalls1 setPosition:ccp(caveWalls2.position.x, caveWalls2.position.y - screenSize.height)];
    }
    if (caveWalls2.position.y  > 720) {
        [caveWalls2 setPosition:ccp(caveWalls1.position.x, caveWalls1.position.y - screenSize.height)];
    }
}

-(void)fadeInLayer {
    isTransitioning = YES;
    
}
@end
