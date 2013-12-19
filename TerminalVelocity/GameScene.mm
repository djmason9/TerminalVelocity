//
//  GameScene.m
//  TerminalVelocity
//
//  Created by Aaron Jones on 6/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "GameplayLayer.h"
#import "SpaceBackgroundLayer.h"
#import "SkyHUDLayer.h"
#import "SkyBackgroundLayer.h"
#import "DayBackgroundLayer.h"
#import "DaySunsetBackgroundLayer.h"
#import "CaveBackgroundLayer.h"
#import "NightBackgroundLayer.h"
#import "RainBackgroundLayer.h"
#import "BackgroundLayer.h"
#import "HUDLayer.h"
#import "SpaceHUDLayer.h"
#import "GameManager.h"
#import "SpaceGameOverLayer.h"
#import "SkyGameOverLayer.h"
#import "GameMusicManager.h"
#import "DayBreakBackgroundLayer.h"
#import "CityBackgroundLayer.h"


@implementation GameScene
@synthesize sceneType;

-(void)dealloc {
    [gameplayLayer release];
    [super dealloc];
}

-(void)loadAllSpriteFrames {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"death_menu_items.plist"];
}

-(id)init{
    self = [super init];
    if (self) {
        sceneType = kNoSceneUninitialized;
        [self loadAllSpriteFrames];
        // Gameplay Layer
        gameplayLayer = [[GameplayLayer node] retain];
        gameplayLayer.tag = kGAMEPLAY_LAYER_TAG;
        [gameplayLayer loadGameObjects];
        
        [self addChild:gameplayLayer z:5];
    }
    return self;
}


-(void)transitionToSpaceScene {

    GameMusicManager *gmm =[GameMusicManager sharedMusicManager];
    [gmm fadeOutMusicToNextSong:kSongSpace];
    
    // Background Layer
    BackgroundLayer *backLayer = [SpaceBackgroundLayer node];
    backLayer.tag = kSPACE_BACKGROUND_LAYER_TAG;
    // HUD Layer
    HUDLayer *hudLayer = [SpaceHUDLayer node];
    hudLayer.tag = kSPACE_HUD_LAYER_TAG;
    
    // Game Over Layer
    GameOverLayer *gameOverLayer = [SpaceGameOverLayer node];
    gameOverLayer.tag = kGAME_OVER_LAYER_TAG;
    gameOverLayer.visible = NO;
    
    gameplayLayer.backgroundLayer = backLayer;
    gameplayLayer.hudLayer = hudLayer;
    gameplayLayer.gameOverLayer = gameOverLayer;
    
    [self addChild:gameOverLayer z:0];
    [self addChild:backLayer z:1];
    [self addChild:hudLayer z:10];
 
    [gameplayLayer transitionToScene:kSpaceScene];
}

-(void)removeSpaceSuit {
    [gameplayLayer->broward removeSpaceSuitAnim];
    [gameplayLayer addGameObjectsForSky];
}


-(void)transitionToSkyDayScene {
    [self unschedule:@selector(transitionToSkyDayScene)];
    GameMusicManager *gmm =[GameMusicManager sharedMusicManager];
    [gmm fadeOutMusicToNextSong:kSongSky];
    
    // HUD Layer
    if (![self getChildByTag:kSKY_HUD_LAYER_TAG]) {
        HUDLayer *hudLayer = [SkyHUDLayer node];
        hudLayer.tag = kSKY_HUD_LAYER_TAG;
        hudLayer->actionButton.isTouchEnabled = NO;
        [gameplayLayer.hudLayer removeFromParentAndCleanup:YES];
        [self addChild:hudLayer z:10];
        gameplayLayer.hudLayer = hudLayer;
    }
    
    // Game Over Layer
    if (![self getChildByTag:kGAME_OVER_LAYER_TAG]) {
        GameOverLayer *gameOverLayer = [SkyGameOverLayer node];
        gameOverLayer.tag = kGAME_OVER_LAYER_TAG;
        gameOverLayer.visible = NO;
        [gameplayLayer.gameOverLayer removeFromParentAndCleanup:YES];
        [self addChild:gameOverLayer z:0];
        gameplayLayer.gameOverLayer = gameOverLayer;
    }
    
    // Background Layer
    BackgroundLayer *backLayer = [DayBackgroundLayer node];
    backLayer.tag = kSKY_DAY_BACKGROUND_LAYER_TAG;
    [gameplayLayer.backgroundLayer fadeOutLayer];
    [self addChild:backLayer z:1];
    gameplayLayer.backgroundLayer = backLayer;
    [backLayer fadeInLayer:self selector:@selector(removeSpaceSuit)];
}

-(void)transitionToSkyNightScene {
    [self unschedule:@selector(transitionToSkyNightScene)];
    GameMusicManager *gmm =[GameMusicManager sharedMusicManager];
    [gmm fadeOutMusicToNextSong:kSongNight];
    
    gameplayLayer->broward.sceneType=kSkyNightScene;
    
    // HUD Layer
    if (![self getChildByTag:kSKY_HUD_LAYER_TAG]) {
        HUDLayer *hudLayer = [SkyHUDLayer node];
        hudLayer.tag = kSKY_HUD_LAYER_TAG;
        hudLayer->actionButton.isTouchEnabled = NO;
        [gameplayLayer.hudLayer removeFromParentAndCleanup:YES];
        [self addChild:hudLayer z:10];
        gameplayLayer.hudLayer = hudLayer;
    }
    
    // Game Over Layer
    if (![self getChildByTag:kGAME_OVER_LAYER_TAG]) {
        GameOverLayer *gameOverLayer = [SkyGameOverLayer node];
        gameOverLayer.tag = kGAME_OVER_LAYER_TAG;
        gameOverLayer.visible = NO;
        [gameplayLayer.gameOverLayer removeFromParentAndCleanup:YES];
        [self addChild:gameOverLayer z:0];
        gameplayLayer.gameOverLayer = gameOverLayer;
    }
    
    // Background Layer
    BackgroundLayer *backLayer = [NightBackgroundLayer node];
    backLayer.tag = kSKY_NIGHT_BACKGROUND_LAYER_TAG;
    backLayer.transitionLayer = gameplayLayer.backgroundLayer;
    
    //[gameplayLayer.backgroundLayer fadeOutLayer];
    gameplayLayer.backgroundLayer = backLayer;
    [self addChild:backLayer z:1];
    
    [backLayer fadeInLayer];
    
}

-(void)transitionToSkyRainScene {
    [self unschedule:@selector(transitionToSkyRainScene)];
    GameMusicManager *gmm =[GameMusicManager sharedMusicManager];
    [gmm fadeOutMusicToNextSong:kSongRain];
    
    // HUD Layer
    if (![self getChildByTag:kSKY_HUD_LAYER_TAG]) {
        HUDLayer *hudLayer = [SkyHUDLayer node];
        hudLayer.tag = kSKY_HUD_LAYER_TAG;
        hudLayer->actionButton.isTouchEnabled = NO;
        [gameplayLayer.hudLayer removeFromParentAndCleanup:YES];
        [self addChild:hudLayer z:10];
        gameplayLayer.hudLayer = hudLayer;
    }
    
    // Game Over Layer
    if (![self getChildByTag:kGAME_OVER_LAYER_TAG]) {
        GameOverLayer *gameOverLayer = [SkyGameOverLayer node];
        gameOverLayer.tag = kGAME_OVER_LAYER_TAG;
        gameOverLayer.visible = NO;
        [gameplayLayer.gameOverLayer removeFromParentAndCleanup:YES];
        [self addChild:gameOverLayer z:0];
        gameplayLayer.gameOverLayer = gameOverLayer;
    }
    
    // Background Layer
    BackgroundLayer *backLayer = [RainBackgroundLayer node];
    backLayer.tag = kSKY_RAIN_BACKGROUND_LAYER_TAG;
    backLayer.transitionLayer = gameplayLayer.backgroundLayer;
    [gameplayLayer.backgroundLayer fadeOutLayer];
    gameplayLayer.backgroundLayer = backLayer;
    [self addChild:backLayer z:1];
    
    [backLayer fadeInLayer];
    
}

-(void)transitionToSkyDayBreakScene {
    [self unschedule:@selector(transitionToSkyDayBreakScene)];
    GameMusicManager *gmm =[GameMusicManager sharedMusicManager];
    [gmm fadeOutMusicToNextSong:kSongSky];
    gameplayLayer->broward.sceneType=kSkyDayScene;
    // Background Layer
    BackgroundLayer *backLayer = [DayBreakBackgroundLayer node];
    backLayer.tag = kSKY_DAY_BREAK_BACKGROUND_LAYER_TAG;
    backLayer.transitionLayer = gameplayLayer.backgroundLayer;
    //[gameplayLayer.backgroundLayer fadeOutLayer];
    gameplayLayer.backgroundLayer = backLayer;
    [self addChild:backLayer z:1];
    
    [backLayer fadeInLayer];
}

-(void)transitionToSkyDaySunsetScene {
    [self unschedule:@selector(transitionToSkyDaySunsetScene)];
    GameMusicManager *gmm =[GameMusicManager sharedMusicManager];
    [gmm fadeOutMusicToNextSong:kSongSky];
    gameplayLayer->broward.sceneType=kSkyDayScene;
    // Background Layer
    BackgroundLayer *backLayer = [DaySunsetBackgroundLayer node];
    backLayer.tag = kSKY_DAY_BREAK_BACKGROUND_LAYER_TAG;
    backLayer.transitionLayer = gameplayLayer.backgroundLayer;
    //[gameplayLayer.backgroundLayer fadeOutLayer];
    gameplayLayer.backgroundLayer = backLayer;
    [self addChild:backLayer z:1];
    
    [backLayer fadeInLayer];
}

-(void)transitionToCityScene {
    [self unschedule:@selector(transitionToCityScene)];
    GameMusicManager *gmm =[GameMusicManager sharedMusicManager];
    [gmm fadeOutMusicToNextSong:kSongCity];
    gameplayLayer->broward.sceneType=kSkyDayScene;
    // Background Layer
    CityBackgroundLayer *backLayer = [CityBackgroundLayer node];
    backLayer.tag = kSKY_DAY_BREAK_BACKGROUND_LAYER_TAG;
    backLayer.transitionLayer = gameplayLayer.backgroundLayer;
    gameplayLayer.backgroundLayer = backLayer;
    backLayer.gameplayLayer = gameplayLayer;
    [self addChild:backLayer z:1];
    
    [backLayer fadeInLayer];
}

-(void)transitionToCaveScene {
    [self unschedule:@selector(transitionToCaveScene)];
    GameMusicManager *gmm =[GameMusicManager sharedMusicManager];
    [gmm fadeOutMusicToNextSong:kSongCity];
    gameplayLayer->broward.sceneType=kSkyDayScene;
    
    // HUD Layer
    if (![self getChildByTag:kSKY_HUD_LAYER_TAG]) {
        HUDLayer *hudLayer = [SkyHUDLayer node];
        hudLayer.tag = kSKY_HUD_LAYER_TAG;
        hudLayer->actionButton.isTouchEnabled = NO;
        [gameplayLayer.hudLayer removeFromParentAndCleanup:YES];
        [self addChild:hudLayer z:10];
        gameplayLayer.hudLayer = hudLayer;
    }
    
    // Game Over Layer
    if (![self getChildByTag:kGAME_OVER_LAYER_TAG]) {
        GameOverLayer *gameOverLayer = [SkyGameOverLayer node];
        gameOverLayer.tag = kGAME_OVER_LAYER_TAG;
        gameOverLayer.visible = NO;
        [gameplayLayer.gameOverLayer removeFromParentAndCleanup:YES];
        [self addChild:gameOverLayer z:0];
        gameplayLayer.gameOverLayer = gameOverLayer;
    }
    
    // Background Layer
    CaveBackgroundLayer *backLayer = [CaveBackgroundLayer node];
    backLayer.tag = kSKY_DAY_BREAK_BACKGROUND_LAYER_TAG;
    ((CityBackgroundLayer *) gameplayLayer.backgroundLayer).scrollBrickWall = YES;
    backLayer.transitionLayer = gameplayLayer.backgroundLayer;
    gameplayLayer.backgroundLayer = backLayer;
    [self addChild:backLayer z:1];
    
    [backLayer fadeInLayer];
}

-(void)transitionToScene:(SceneTypes)type {
    sceneType = type;
    switch (type) {
        case kSpaceScene:{
            [self transitionToSpaceScene];
            break;
        }
        case kSkyDayScene: {
            [gameplayLayer transitionToScene:kSkyDayScene];
            [self schedule:@selector(transitionToSkyDayScene) interval:1.0f];
            break;
        }
        case kSkyNightScene: {
            [gameplayLayer transitionToScene:kSkyNightScene];
            [self schedule:@selector(transitionToSkyNightScene)];
            break;
        }
        case kSkyRainScene: {
            [gameplayLayer transitionToScene:kSkyRainScene];
            [self schedule:@selector(transitionToSkyRainScene)];
            break;
        }
        case kSkyDayBreakScene: {
            [gameplayLayer transitionToScene:kSkyDayBreakScene];
            [self schedule:@selector(transitionToSkyDayBreakScene)];
            break;
        }
        case kSkyDaySunsetScene: {
            [gameplayLayer transitionToScene:kSkyDaySunsetScene];
            [self schedule:@selector(transitionToSkyDaySunsetScene)];
            break;
        }
        case kCityScene: {
            [gameplayLayer transitionToScene:kCityScene];
            [self schedule:@selector(transitionToCityScene)];
            break;
        }
        case kCaveScene: {
            [gameplayLayer transitionToScene:kCaveScene];
            [self schedule:@selector(transitionToCaveScene)];
            break;
        }
        default:
            break;
    }
}


@end
