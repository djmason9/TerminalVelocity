//
//  DayBreakBackgroundLayer.m
//  TerminalVelocity
//
//  Created by Aaron Jones on 9/4/11.
//  Copyright (c) 2011 Dark Energy Studios. All rights reserved.
//

#import "DayBreakBackgroundLayer.h"
#import "SkySunsetLayer.h"
#import "GameManager.h"

@implementation DayBreakBackgroundLayer
- (id)init {
    self = [super init];
    if (self) {
        backgroundImage = [[SkySunsetLayer layerWithColor:ccc4(0,183,183,255) fadingTo:ccc4(218,75,1,255) alongVector:ccp(0, -1)] retain];
        [backgroundImage setPosition:CGPointMake(0, 0)];        
        [self addChild:backgroundImage];
        
        spriteBatchNode = [[CCSpriteBatchNode batchNodeWithFile:@"sky_scene_items.png"] retain];
        [self addChild:spriteBatchNode];
        
        // sun
        sun = [[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"sun.png"]] retain];
        [sun setPosition:CGPointMake(screenSize.width/2.0f, -9)];
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
    
    if(transitionTime > TRANSTION_TIME_SKY_DAY_BREAK && !isTransitioningOut){
        isTransitioningOut = YES;
        [[GameManager sharedGameManager] transitionToSceneWithID:kCityScene];
        
    }
    
    if (isTransitioningOut) {
        return;
    }
    
    if (isTransitioning) {
        [transitionLayer updateScroll:deltaTime pos:pos];
        float rate = 500.0f / pos.y;
        [cloudsLayer updateBackCloudsPosition:rate];
        [cloudsLayer updateFrontCloudsPosition:rate];
    } else if (!isTransitioning && transitionLayer != nil) {
        [transitionLayer removeFromParentAndCleanup:YES];
        [transitionLayer release];
        transitionLayer = nil;
        //HUDLayer *hud = (HUDLayer *)[self.parent getChildByTag:kSKY_HUD_LAYER_TAG];
        //hud->actionButton.isTouchEnabled = YES;
    }
    
    
    if (pos.y > 0 && !isTransitioning) {
        float rate = 500.0f / pos.y;
        [cloudsLayer updateBackCloudsPosition:rate];
        [cloudsLayer updateFrontCloudsPosition:rate];
        
        
        if (sun.position.y > -10 && sun.position.y < (screenSize.height * 0.5f)) {
            // default 0.1
            sun.position = ccp(sun.position.x, sun.position.y + ((0.2)*rate));
            [(SkySunsetLayer *)backgroundImage stepSunRiseChange];
            
        }
    }
}

-(void)setOpacity:(GLubyte)o{
    CCSprite *s = nil;
    CCARRAY_FOREACH(spriteBatchNode.children, s) {
        [s setOpacity:o];
    }
}

-(void)fadeInLayer {
    [super fadeInLayer];
    [((SkySunsetLayer *)backgroundImage) setOpacity:0];
    id fadeInAction = [CCFadeIn actionWithDuration:1.0];
    [backgroundImage runAction:fadeInAction];
}
@end
