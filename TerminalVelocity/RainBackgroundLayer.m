//
//  RainBackgroundLayer.m
//  TerminalVelocity
//
//  Created by Aaron Jones on 9/3/11.
//  Copyright (c) 2011 Dark Energy Studios. All rights reserved.
//

#import "RainBackgroundLayer.h"
#import "SkyCloud.h"
#import "GameManager.h"
#import <tgmath.h>

@implementation RainBackgroundLayer
- (void)dealloc {
    [[CCTextureCache sharedTextureCache] removeTextureForKey:@"rain_scene_items.png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"rain_scene_items.plist"];
    [rainBackgroundImage1 release];
    [rainBackgroundImage2 release];
    [lighning1 release];
    [lighning2 release];
    [lighning3 release];
    [lighning4 release];
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        lighningTime = 0.0f;
        backgroundImage = [[CCLayerGradient alloc] initWithColor:ccc4(152, 152, 152, 255) fadingTo:ccc4(196, 196, 196, 255) alongVector:ccp(0,-1)];        
        [backgroundImage setPosition:CGPointMake(0, 0)];
        [(CCLayerGradient *)backgroundImage setOpacity:0];
        [self addChild:backgroundImage];
        
        spriteBatchNode = [[CCSpriteBatchNode batchNodeWithFile:@"rain_scene_items.png"] retain];
        [self addChild:spriteBatchNode];
        
        //backgroundImage = [[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rain_background.png"]]retain];
        //[backgroundImage setPosition:CGPointMake(screenSize.width/2.0f, screenSize.height/2.0f)];
        //[spriteBatchNode addChild:backgroundImage];
        
        lighning1 = [[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"lightning_bg4.png"]] retain];
        [lighning1 setPosition:CGPointMake(screenSize.width/2.0f, screenSize.height/2.0f)];
        lighning1.visible = NO;
        [spriteBatchNode addChild:lighning1];
        
        lighning2 = [[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"lightning_bg2.png"]] retain];
        [lighning2 setPosition:CGPointMake(screenSize.width/2.0f, screenSize.height/2.0f)];
        lighning2.visible = NO;
        [spriteBatchNode addChild:lighning2];
        
        rainBackgroundImage1 = [[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rain.png"]] retain];
        [rainBackgroundImage1 setPosition:CGPointMake(screenSize.width/2.0f, screenSize.height/2.0f)];
        [rainBackgroundImage1 setOpacity:0];
        [spriteBatchNode addChild:rainBackgroundImage1];
        
        rainBackgroundImage2 = [[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rain.png"]] retain];
        [rainBackgroundImage2 setPosition:CGPointMake(screenSize.width/2.0f, screenSize.height + (screenSize.height/2.0f))];
        [rainBackgroundImage2 setOpacity:0];
        [spriteBatchNode addChild:rainBackgroundImage2];
        
        
        
        // city
        cityFront.position = ccp(screenSize.width/2.0f, 40);
        [self addChild:cityFront];
        
        // clouds
        cloudsLayer = [[SkyCloudsLayer node] retain];
        cloudsLayer.cloudType = kSkyGrayCloud;
        [cloudsLayer createClouds];
        [self addChild:cloudsLayer];
    }
    return self;
}

-(void)showLighning {
    int rand = arc4random() % 2;
    switch (rand) {
        case 0:
            [lighning1 runAction:[CCSequence actions:[CCShow action], [CCFadeOut actionWithDuration:0.5f], [CCHide action], nil]];
            break;
        case 1:
            [lighning2 runAction:[CCSequence actions:[CCShow action], [CCFadeOut actionWithDuration:0.5f], [CCHide action], nil]];
        default:
            break;
    }
}

-(void)updateScroll:(ccTime)deltaTime pos:(CGPoint)pos {
    transitionTime += deltaTime;
    
    if ([GameManager sharedGameManager].hasPlayerDied) {
        spriteBatchNode.visible = NO;
        self.visible = NO;
        return;
    }
    
    if(transitionTime > TRANSTION_TIME_SKY_RAIN && !isTransitioningOut){
        isTransitioningOut = YES;
        [[GameManager sharedGameManager] transitionToSceneWithID:kSkyDaySunsetScene];
        
        //monsoon madness complete the rain scene
        GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper]; 
        GKAchievement* achievement = [gkHelper getAchievementByID:@"monsoonMadness"];//monsoonMadness
        float percent = 100; 
        [gkHelper reportAchievementWithID:achievement.identifier percentComplete:percent];        
        
        [self objectsAchievmentIsComplete:achievement.identifier achievementTitle:@"Monsoon Madness"];

        
    }
    
    //if(fmod(transitionTime, 4.0)>0 && fmod(transitionTime, 4.0)<.02)
      //  NSLog(@"Time: %f", fmod(transitionTime, 4.0));
    
    if (isTransitioning) {
        [transitionLayer updateScroll:deltaTime pos:pos];
    } else if (!isTransitioning && transitionLayer != nil) {
        [transitionLayer removeFromParentAndCleanup:YES];
        [transitionLayer release];
        transitionLayer = nil;
        [lighning1 runAction:[CCSequence actions:[CCShow action], [CCFadeOut actionWithDuration:0.5f], [CCHide action], nil]];
    }
    
    if (pos.y > 0) {
        float rate = 500.0f / pos.y;
        
        [cloudsLayer updateBackCloudsPosition:rate];
        [cloudsLayer updateFrontCloudsPosition:rate];
        
        float rate2 = pos.y/100.0f;
        rainBackgroundImage1.position = ccp(rainBackgroundImage1.position.x, rainBackgroundImage1.position.y - rate2);
        rainBackgroundImage2.position = ccp(rainBackgroundImage2.position.x, rainBackgroundImage2.position.y - rate2);
        
        if (rainBackgroundImage1.position.y  < -240) {
            [rainBackgroundImage1 setPosition:ccp(rainBackgroundImage2.position.x, rainBackgroundImage2.position.y + screenSize.height)];
        }
        if (rainBackgroundImage2.position.y  < -240) {
            [rainBackgroundImage2 setPosition:ccp(rainBackgroundImage1.position.x, rainBackgroundImage1.position.y + screenSize.height)];
        }
        lighningTime += deltaTime;
        if (lighningTime > 5.0f) {
            lighningTime = 0.0f;
            [self showLighning];
        }
        
    }
}

-(void)fadeInLayer {
    [super fadeInLayer];
   
    [backgroundImage runAction:[CCFadeIn actionWithDuration:1.0]];
}

-(void)fadeOutLayer {
    [super fadeOutLayer];
    [backgroundImage runAction:[CCFadeOut actionWithDuration:1.0]];
}
@end
