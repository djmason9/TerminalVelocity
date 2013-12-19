//
//  CloudBackgroundLayer.m
//  TerminalVelocity
//
//  Created by Aaron Jones on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#define boris_random(smallNumber, bigNumber) ((((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * (bigNumber - smallNumber)) + smallNumber) 

#import "SkyBackgroundLayer.h"
#import "GameManager.h"
#import "GameMusicManager.h"
#import "SimpleAudioEngine.h"
#import "SkyCloud.h"
#import "HUDLayer.h"

// Defines for Cloud Scrolling Scene
#define kMaxCloudMoveDuration 10
#define kMinCloudMoveDuration 1

@implementation SkyBackgroundLayer
-(void)dealloc {
    [cloudsLayer release];
    [cityFront release];
    [backgroundImage release];
    [super dealloc];
}

-(id)init {
    self = [super init];
    if (self) {
        transitionTime = 0;
        
        // city
        cityFront = [[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"city.png"]] retain];
        
        
        float cityYoffset = -1*screenSize.height;
        cityFront.position = ccp(screenSize.width/2.0f, cityYoffset+40);
        
        //[self addChild:cityFront];
        
        
    }
    return self;
}

/*
-(void)hideClearSky {
    backgroundImage.visible = NO;
    spriteBatchNode.visible = NO;
}

-(void)hideRainSky {
    //spriteBatchNode2.visible = NO;
    //[spriteBatchNode2 removeFromParentAndCleanup:YES];
}

-(void)updateScene:(ccTime)deltaTime {
    elapsedTime += deltaTime;
    
    
}
 */

/*
-(void)updateScroll:(ccTime)deltaTime pos:(CGPoint)pos {
    if (isTransitioning) {
        return;
    }
    
    //[super updateScroll:deltaTime pos:pos];
    //if (!spriteBatchNode2.visible) {
        transitionTime += deltaTime;
    //}
   
    if ([GameManager sharedGameManager].hasPlayerDied) {
        spriteBatchNode.visible = NO;
        spriteBatchNode2.visible = NO;
        self.visible = NO;
        return;
    }
    
    if (backgroundImage.position.y < 0  && !isTransitioning) {
         float rate = 2000.0f / pos.y;
        backgroundImage.position = ccp(backgroundImage.position.x, backgroundImage.position.y + rate);
        skyInTransision.position = ccp(skyInTransision.position.x, skyInTransision.position.y + rate);
        
        cityFront.position = ccp(cityFront.position.x, cityFront.position.y + rate);
        [self updateBackCloudsPosition:rate];
        [self updateFrontCloudsPosition:rate];
        
        
    } else if (pos.y > 0 && !isTransitioning) {
        HUDLayer *hud = (HUDLayer *)[self.parent getChildByTag:400];
        hud->actionButton.isTouchEnabled = YES;
        skyInTransision.visible = NO;
        float rate = 500.0f / pos.y;
        [self updateBackCloudsPosition:rate];
        [self updateFrontCloudsPosition:rate];
        [self updateRainBackCloudsPosition:rate];
        [self updateRainFrontCloudsPosition:rate];
        
    
        
        if (sun.position.y > 70) {
            // default 0.1
            sun.position = ccp(sun.position.x, sun.position.y - ((GAME_RATE_MULT_SKY*0.1)*rate));
           
        } else if (sun.position.y < 70 &&  sun.position.y > -10) {
            
            static float changePoint = 0;
            changePoint += ((GAME_RATE_MULT_SKY*0.1)*rate);
            // 0.05 default
            sun.position = ccp(sun.position.x, sun.position.y - ((GAME_RATE_MULT_SKY*0.05)*rate));
            
            if (changePoint > 1) {
                changePoint = 0;
                [backgroundImage stepSunsetChange];
            }
            
        } else {
            nightBackground.visible = YES;
            static BOOL nightShowing = NO;
            if (!nightShowing) {
                [[GameMusicManager sharedMusicManager] fadeOutMusicToNextSong:kSongNight];
                nightShowing = YES;
                nightBackground.opacity = 0;
                [nightBackground runAction:[CCFadeIn actionWithDuration:1.0f]];
               
            }
            
        }
    } else if(pos.y > 0 && isTransitioning) {
        float rate = 2000.0f / pos.y;
        [self updateBackCloudsPosition:rate];
        [self updateFrontCloudsPosition:rate];
         
    }
    
    if (pos.y > 0) {
        float rate = 500.0f / pos.y;
        //[self updateBackCloudsPosition:rate];
        //[self updateFrontCloudsPosition:rate];
        //[self updateRainBackCloudsPosition:rate];
        //[self updateRainFrontCloudsPosition:rate];
    }
    
    
    if (spriteBatchNode2.visible) {
        float rate = 3000.0f / pos.y;
        rainBackgroundImage1.position = ccp(rainBackgroundImage1.position.x, rainBackgroundImage1.position.y - rate);
        rainBackgroundImage2.position = ccp(rainBackgroundImage2.position.x, rainBackgroundImage2.position.y - rate);
        
        if (rainBackgroundImage1.position.y  < -240) {
            [rainBackgroundImage1 setPosition:ccp(rainBackgroundImage2.position.x, rainBackgroundImage2.position.y + screenSize.height)];
        }
        if (rainBackgroundImage2.position.y  < -240) {
            [rainBackgroundImage2 setPosition:ccp(rainBackgroundImage1.position.x, rainBackgroundImage1.position.y + screenSize.height)];
        }
    }
    
    
    if (transitionTime > 60.0 && !spriteBatchNode2.visible) {
        
        PLAYSOUNDEFFECT(THUNDER);
        [[GameMusicManager sharedMusicManager] fadeOutMusicToNextSong:kSongRain];
        
        spriteBatchNode2.visible = YES;
        id fadeIn = [CCFadeIn actionWithDuration:1.5f];
        id call = [CCCallFunc actionWithTarget:self selector:@selector(hideClearSky)];
        
        for (CCNode *node in spriteBatchNode2.children) {
            [node runAction:[CCSequence actions:[fadeIn copy], [call copy], nil]];
        }
        //[spriteBatchNode runAction:[CCSequence actions:fadeOut, call, nil]];
    } else if(transitionTime > 120.0 && !spriteBatchNode.visible) {
        backgroundImage.visible = YES;
        spriteBatchNode.visible = YES;
        id fadeIn = [CCFadeIn actionWithDuration:1.5f];
        id call = [CCCallFunc actionWithTarget:self selector:@selector(hideRainSky)];
        [backgroundImage runAction:[CCSequence actions:[fadeIn copy],call, nil]];
        for (CCNode *node in spriteBatchNode.children) {
            [node runAction:[fadeIn copy]];
        }
    }
}
 */

@end
