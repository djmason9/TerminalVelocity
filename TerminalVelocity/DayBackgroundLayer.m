//
//  ClearBackgroundLayer.m
//  TerminalVelocity
//
//  Created by Aaron Jones on 9/3/11.
//  Copyright (c) 2011 Dark Energy Studios. All rights reserved.
//

#import "DayBackgroundLayer.h"
#import "SkySunsetLayer.h"
#import "GameManager.h"
#import "HUDLayer.h"
#import "SkyCloud.h"

@implementation DayBackgroundLayer

- (void)dealloc {
    [[CCTextureCache sharedTextureCache] removeTextureForKey:@"sky_scene_items.png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"sky_scene_items.plist"];
    [sun release];
    [skyInTransision release];
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        spriteBatchNode = [[CCSpriteBatchNode batchNodeWithFile:@"sky_scene_items.png"] retain];
        
        skyInTransision = [[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"transition-hd.png"]] retain];
        [skyInTransision setPosition:CGPointMake(screenSize.width/2.0f, screenSize.height/2.0f)];
        
        backgroundImage = [[SkySunsetLayer layerWithColor:ccc4(183,215,229,255) fadingTo:ccc4(218,242,255,255) alongVector:ccp(0, -1)] retain];
        [backgroundImage setPosition:CGPointMake(0, (screenSize.height* -1.0f))];        
        
        [self addChild:backgroundImage];
        [self addChild:spriteBatchNode];
        [spriteBatchNode addChild:skyInTransision];
        
        // sun
        sun = [[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"sun.png"]] retain];
        [sun setPosition:CGPointMake(screenSize.width/2.0f, screenSize.height/2.0f)];
        [spriteBatchNode addChild:sun];
        
        
        // city
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
    
    if(transitionTime > TRANSTION_TIME_SKY_DAY && !isTransitioningOut){
        isTransitioningOut = YES;
        [[GameManager sharedGameManager] transitionToSceneWithID:kSkyRainScene];
        
    }
    
    /*if (isTransitioning) {
        return;
    }*/
    
    
    if (backgroundImage.position.y < 0  && !isTransitioning) {
        float rate = 2000.0f / pos.y;
        backgroundImage.position = ccp(backgroundImage.position.x, backgroundImage.position.y + rate);
        skyInTransision.position = ccp(skyInTransision.position.x, skyInTransision.position.y + rate);
        
        cityFront.position = ccp(cityFront.position.x, cityFront.position.y + rate);
        [cloudsLayer updateBackCloudsPosition:rate];
        [cloudsLayer updateFrontCloudsPosition:rate];
        
        
    } else if (pos.y > 0 && !isTransitioning) {
        HUDLayer *hud = (HUDLayer *)[self.parent getChildByTag:kSKY_HUD_LAYER_TAG];
        hud->actionButton.isTouchEnabled = YES;
        skyInTransision.visible = NO;
        float rate = 500.0f / pos.y;
        
        [cloudsLayer updateBackCloudsPosition:rate];
        [cloudsLayer updateFrontCloudsPosition:rate];
        
        
        //if (sun.position.y > 70) {
            // default 0.1
            //sun.position = ccp(sun.position.x, sun.position.y - ((GAME_RATE_MULT_SKY*0.1)*rate));
            
        //} else if (sun.position.y < 70 &&  sun.position.y > -10) {
            
        //    static float changePoint = 0;
        //    changePoint += ((GAME_RATE_MULT_SKY*0.1)*rate);
            // 0.05 default
            //sun.position = ccp(sun.position.x, sun.position.y - ((GAME_RATE_MULT_SKY*0.05)*rate));
            
            /*if (changePoint > 1) {
                changePoint = 0;
                [(SkySunsetLayer *)backgroundImage stepSunsetChange];
                [(SkySunsetLayer *)backgroundImage stepSunsetChange];
                [(SkySunsetLayer *)backgroundImage stepSunsetChange];
                [(SkySunsetLayer *)backgroundImage stepSunsetChange];
            }*/
            
       // }
    }
}

-(void)fadeInLayer {
    [super fadeInLayer];
    [((SkySunsetLayer *)backgroundImage) setOpacity:0];
    [backgroundImage runAction:[CCFadeIn actionWithDuration:1.0]];
}

-(void)fadeOutLayer {
    [super fadeOutLayer];
     [backgroundImage runAction:[CCFadeOut actionWithDuration:1.0]];
}
@end
