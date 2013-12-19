//
//  NightBackgroundLayer.m
//  TerminalVelocity
//
//  Created by Aaron Jones on 9/3/11.
//  Copyright (c) 2011 Dark Energy Studios. All rights reserved.
//

#import "NightBackgroundLayer.h"
#import "HUDLayer.h"
#import "GameManager.h"

@implementation NightBackgroundLayer
- (id)init {
    self = [super init];
    if (self) {
        spriteBatchNode = [[CCSpriteBatchNode batchNodeWithFile:@"sky_scene_items.png"] retain];
        [self addChild:spriteBatchNode];
        
        // night scene
        backgroundImage = [[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"night_background.png"]] retain];
        [backgroundImage setPosition:CGPointMake(screenSize.width/2.0f, screenSize.height/2.0f)];
        [spriteBatchNode addChild:backgroundImage];
        
        // city
        cityFront.position = ccp(screenSize.width/2.0f, 40);
        [spriteBatchNode addChild:cityFront];
        
        cloudsLayer = [[SkyCloudsLayer node] retain];
        [cloudsLayer createClouds];
        [self addChild:cloudsLayer];
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
    
    if(transitionTime > TRANSTION_TIME_SKY_NIGHT && !isTransitioningOut){
        isTransitioningOut = YES;
        [[GameManager sharedGameManager] transitionToSceneWithID:kSkyDayBreakScene];
        
    }
    
    if (isTransitioning) {
        [transitionLayer updateScroll:deltaTime pos:pos];
        //NSLog(@"Scrolling transitionLayer!!!!!!");
    } else if (!isTransitioning && transitionLayer != nil) {
        [transitionLayer removeFromParentAndCleanup:YES];
        [transitionLayer release];
        transitionLayer = nil;
        //HUDLayer *hud = (HUDLayer *)[self.parent getChildByTag:kSKY_HUD_LAYER_TAG];
        //hud->actionButton.isTouchEnabled = YES;
    }
    
    if (pos.y > 0) {
        float rate = 500.0f / pos.y;
        
        [cloudsLayer updateBackCloudsPosition:rate];
        [cloudsLayer updateFrontCloudsPosition:rate];
        
    }
}
@end
