//
//  DaySunsetBackgroundLayer.m
//  TerminalVelocity
//
//  Created by Aaron Jones on 9/7/11.
//  Copyright (c) 2011 Dark Energy Studios. All rights reserved.
//

#import "DaySunsetBackgroundLayer.h"
#import "SkySunsetLayer.h"
#import "GameManager.h"
#import "HUDLayer.h"
#import "SkyCloud.h"

@implementation DaySunsetBackgroundLayer
- (void)dealloc {
    [sun release];
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        spriteBatchNode = [[CCSpriteBatchNode batchNodeWithFile:@"sky_scene_items.png"] retain];
        
        backgroundImage = [[SkySunsetLayer layerWithColor:ccc4(183,215,229,255) fadingTo:ccc4(218,242,255,255) alongVector:ccp(0, -1)] retain];
        [backgroundImage setPosition:CGPointMake(0, 0)];        
        
        [self addChild:backgroundImage];
        [self addChild:spriteBatchNode];
        
        // sun
        sun = [[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"sun.png"]] retain];
        [sun setPosition:CGPointMake(screenSize.width/2.0f, screenSize.height/2.0f)];
        [spriteBatchNode addChild:sun];
        
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
    
    if(transitionTime > TRANSTION_TIME_SKY_SUNSET && !isTransitioningOut){
        isTransitioningOut = YES;
        [[GameManager sharedGameManager] transitionToSceneWithID:kSkyNightScene];
        
    }
    
    if (isTransitioning) {
        [transitionLayer updateScroll:deltaTime pos:pos];
    } else if (!isTransitioning && transitionLayer != nil) {
        [transitionLayer removeFromParentAndCleanup:YES];
        [transitionLayer release];
        transitionLayer = nil;
    }
    
    
   if (pos.y > 0) {
        HUDLayer *hud = (HUDLayer *)[self.parent getChildByTag:kSKY_HUD_LAYER_TAG];
        hud->actionButton.isTouchEnabled = YES;
        float rate = 500.0f / pos.y;
        
        [cloudsLayer updateBackCloudsPosition:rate];
        [cloudsLayer updateFrontCloudsPosition:rate];
        
        
        if (sun.position.y > 70) {
            //GAME_RATE_MULT_SKY*
            // default 0.1
            sun.position = ccp(sun.position.x, sun.position.y - ((0.2)*rate));
            
        } else if (sun.position.y < 70 &&  sun.position.y > -10) {
            
            static float changePoint = 0;
            changePoint += ((0.1)*rate);
            // 0.05 default
            sun.position = ccp(sun.position.x, sun.position.y - ((0.05)*rate));
            
            if (changePoint > 1) {
                changePoint = 0;
                [(SkySunsetLayer *)backgroundImage stepSunsetChange];
                [(SkySunsetLayer *)backgroundImage stepSunsetChange];
                //[(SkySunsetLayer *)backgroundImage stepSunsetChange];
                //[(SkySunsetLayer *)backgroundImage stepSunsetChange];
            }
            
        }
    }
}

-(void)fadeInLayer {
    [super fadeInLayer];
    [((SkySunsetLayer *)backgroundImage) setOpacity:0];
    id fadeInAction = [CCFadeIn actionWithDuration:1.0];
    [backgroundImage runAction:fadeInAction];
}
@end
