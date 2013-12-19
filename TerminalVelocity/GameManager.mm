//
//  GameManager.m
//  TerminalVelocity
//
//  Created by Aaron Jones on 6/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameManager.h"
#import "MainMenuScene.h"
#import "LoadingScene.h"
#import "HUDLayer.h"
#import "ButtonControl.h"
//#import "OptionsScene.h"
//#import "CreditsScene.h"
//#import "IntroScene.h"
//#import "LevelCompleteScene.h"

@implementation GameManager
static GameManager *_sharedGameManager = nil;
@synthesize isMusicON;
@synthesize isSoundEffectsON;
@synthesize hasPlayerDied;
@synthesize isPaused,isInstructions;
@synthesize score;
@synthesize difficultyLevel;

+(GameManager*)sharedGameManager {
    @synchronized([GameManager class])
    {
        if(!_sharedGameManager)
            [[self alloc] init];
        return _sharedGameManager;
    }
    return nil;
}

+(id)alloc
{
    @synchronized ([GameManager class])
    {
        NSAssert(_sharedGameManager == nil,
                 @"Attempted to allocate a second instance of the Game Manager singleton");
        _sharedGameManager = [super alloc];
        return _sharedGameManager;
    }
    return nil;
}

-(id)init {
    self = [super init];
    if (self != nil) {
        // Game Manager initialized
        CCLOG(@"Game Manager Singleton, init");
        isMusicON = YES;
        isSoundEffectsON = YES;
        hasPlayerDied = NO;
        isPaused = NO;
        score = 0;
        difficultyLevel = kDifficultyMed;
        currentScene = kNoSceneUninitialized;
    }
    return self;
}

-(void)runSceneWithID:(SceneTypes)sceneID {
    SceneTypes oldScene = currentScene;
    currentScene = sceneID;
    id sceneToRun = nil;
    switch (sceneID) {
        case kMainMenuScene:
            sceneToRun = [MainMenuScene node];
            break;
        case kSpaceScene: {
            sceneToRun = [GameScene node];
            [sceneToRun transitionToSceneWithID:kSpaceScene];
            break;
        }
        case kSkyDayScene:
            sceneToRun = [GameScene node];
            break;
            
        default:
            CCLOG(@"Unknown ID, cannot switch scenes");
            return;
            break;
    }
    
    if (sceneToRun == nil) {
        // Revert back, since no new scene was found
        currentScene = oldScene;
        return;
    }
    
    if ([[CCDirector sharedDirector] runningScene] == nil) {
        [[CCDirector sharedDirector] runWithScene:sceneToRun];
        
    } else {
        [[CCDirector sharedDirector] replaceScene:sceneToRun];
    }
}

-(void)runSceneWithID:(SceneTypes)sceneID useLoadScene:(BOOL)userLoadScene {
    [[CCDirector sharedDirector] replaceScene:[LoadingScene sceneWithTargetScene:sceneID]];
}

-(void)callBack:(id)data {
    //CCTexture2D *tex = (CCTexture2D *)data;
    //[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"plist" texture:tex];
}

-(void)callBackSkyDayScene:(id)data {
    CCTexture2D *tex = (CCTexture2D *)data;
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"sky_scene_items.plist" texture:tex];
    GameScene *gameScene = (GameScene *)[[CCDirector sharedDirector] runningScene];
    [gameScene transitionToScene:transitionToScene];
}

-(void)callBackSkyRainScene:(id)data {
    CCTexture2D *tex = (CCTexture2D *)data;
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"rain_scene_items.plist" texture:tex];
    GameScene *gameScene = (GameScene *)[[CCDirector sharedDirector] runningScene];
    [gameScene transitionToScene:transitionToScene];
}

-(void)callBackCityScene:(id)data {
    CCTexture2D *tex = (CCTexture2D *)data;
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"city_items.plist" texture:tex];
    GameScene *gameScene = (GameScene *)[[CCDirector sharedDirector] runningScene];
    [gameScene transitionToScene:transitionToScene];
}

-(void)callBackCaveScene:(id)data {
    CCTexture2D *tex = (CCTexture2D *)data;
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"cave_items.plist" texture:tex];
    GameScene *gameScene = (GameScene *)[[CCDirector sharedDirector] runningScene];
    [gameScene transitionToScene:transitionToScene];
}

-(void)loadSpriteSheetForScene:(SceneTypes) scene {
    switch (scene) {
        case kSpaceScene: {
            [[CCTextureCache sharedTextureCache] addImageAsync:@"space_scene_items.png" target:self selector:@selector(callBack:)];
            break;
        }
        case kSkyDayScene: {
            [[CCTextureCache sharedTextureCache] addImageAsync:@"sky_scene_items.png" target:self selector:@selector(callBackSkyDayScene:)];
            break;
        }
        case kSkyRainScene: {
            [[CCTextureCache sharedTextureCache] addImageAsync:@"rain_scene_items.png" target:self selector:@selector(callBackSkyRainScene:)];
            break;
        }
        case kSkyDaySunsetScene: {
            [[CCTextureCache sharedTextureCache] addImageAsync:@"sky_scene_items.png" target:self selector:@selector(callBackSkyDayScene:)];
            break;
        }
        case kSkyNightScene: {
            [[CCTextureCache sharedTextureCache] addImageAsync:@"sky_scene_items.png" target:self selector:@selector(callBackSkyDayScene:)];
            break;
        }
        case kSkyDayBreakScene: {
            [[CCTextureCache sharedTextureCache] addImageAsync:@"sky_scene_items.png" target:self selector:@selector(callBackSkyDayScene:)];
            break;
        }
        case kCityScene: {
            [[CCTextureCache sharedTextureCache] addImageAsync:@"city_items.png" target:self selector:@selector(callBackCityScene:)];
            break;
        }
        case kCaveScene: {
            [[CCTextureCache sharedTextureCache] addImageAsync:@"cave_items.png" target:self selector:@selector(callBackCaveScene:)];
            break;
        }
        default:
            break;
    }
}

-(void)transitionToSceneWithID:(SceneTypes)sceneID {
    transitionToScene = sceneID;
    [self loadSpriteSheetForScene:sceneID];

    //GameScene *gameScene = (GameScene *)[[CCDirector sharedDirector] runningScene];
    //[gameScene transitionToScene:sceneID];
}


-(CGSize)getDimensionsOfCurrentScene {
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    return screenSize;
}

-(void)pauseRunningScene {
    if (isPaused) {
        [[CCDirector sharedDirector] resume];
    } else {
        [[CCDirector sharedDirector] pause];
    }
}

@end
