//
//  Constants.h
//  TerminalVelocity
//
//  Created by Aaron Jones on 6/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#define kGAMEPLAY_LAYER_TAG 69
#define kGAME_OVER_LAYER_TAG 96
#define kSPACE_GAME_OVER_TAG 97

#define kSPACE_BACKGROUND_LAYER_TAG 100

#define kSKY_DAY_BACKGROUND_LAYER_TAG 200
#define kSKY_NIGHT_BACKGROUND_LAYER_TAG 201
#define kSKY_RAIN_BACKGROUND_LAYER_TAG 202
#define kSKY_DAY_BREAK_BACKGROUND_LAYER_TAG 203


#define kSPACE_HUD_LAYER_TAG 300
#define kSKY_HUD_LAYER_TAG 400

// wait times for game objects
//
#define WAIT_TIME_BIRD 2
#define WAIT_TIME_RELOAD_ROCKET 24
#define WAIT_TIME_PLANE 10

// change game rate for scene
//
#if COCOS2D_DEBUG
#define TRANSTION_TIME_SKY_DAY 5
#define TRANSTION_TIME_SKY_RAIN 5
#define TRANSTION_TIME_SKY_SUNSET 5
#define TRANSTION_TIME_SKY_NIGHT 5
#define TRANSTION_TIME_SKY_DAY_BREAK 5
#define TRANSTION_TIME_CITY 5
#define TRANSTION_TIME_CAVE 5
#define SPACE_SCENE_RATE 0.001f
#else
#define TRANSTION_TIME_SKY_DAY 120
#define TRANSTION_TIME_SKY_RAIN 120
#define TRANSTION_TIME_SKY_SUNSET 45
#define TRANSTION_TIME_SKY_NIGHT 120
#define TRANSTION_TIME_SKY_DAY_BREAK 45
#define TRANSTION_TIME_CITY 120
#define TRANSTION_TIME_CAVE 180
#define SPACE_SCENE_RATE 0.00001f
#endif

#define VECTOR_PTM_RATIO 100.0f
#define PTM_RATIO ((UI_USER_INTERFACE_IDIOM() == \
UIUserInterfaceIdiomPad) ? 100.0 : 50.0)

#define kMainMenuTagValue 10
#define kSceneMenuTagValue 20

// constants used by Broward
#define kBrowardSpriteZValue 100
#define kBrowardSpriteTagValue 0
#define kBrowardIdleTimer 3.0f
#define kBrowardFistDamage 10

#define kDifficultyEasy 0.2
#define kDifficultyMed 0
#define kDifficultyHard -0.2

//music constants
#define kSpaceSongDuration 56.8
#define kSkySongDuration 105.5
#define kRainSongDuration 138.0
#define kCitySongDuration 198.0

#define kEasy 0
#define kNormal 1
#define kHard 2

#define kSongSpace 0
#define kSongSky 1
#define kSongRain 2
#define kSongCity 3
#define kSongNight 4
#define kSongEnd 5

typedef enum {
    kNoSceneUninitialized=0,
    kMainMenuScene=1,
    kOptionsScene=2,
    kCreditsScene=3,
    kIntroScene=4,
    kSpaceScene=5,
    kSkyDayScene=6,
    kSkyNightScene=7,
    kSkyRainScene=8,
    kSkyDayBreakScene=9,
    kSkyDaySunsetScene=10,
    kCityScene=11,
    kCaveScene=12,
    kRainScene=13
} SceneTypes;

typedef enum {
    kObjectTypeNone,
    kBroward,
    kBrowardSpace,
    kBrowardSky,
    kBird,
    kBat,
    kGargoyle,
    kOwl,
    kUmbrella,
    kLightning,
    kReload,
    kReloadRocket,
    kRoot,
    kBees,
    kFirework,
    kGlowBug,
    kPigeon,
    kAlienShip,
    kAsteroid,
    kSatilite,
    kTrash,
    kPig,
    kPlane,
    kBlimp,
    kBra,
    kSmallObject,
    kMediumObject,
    kLargeObject,
    kKillObject
} GameObjectType;

typedef enum {
    kActionControlButton
} GameActionControl;

typedef enum {
    kStateSpawning,
    kStateIdle,
    kStateFalling,
    kStateActionButtonPressed,
    kStateHitBroward,
    kStateHitSmallObject,
    kStateHitMediumObject,
    kStateHitLargeObject,
    kStateDead,
    kStateSmoking,
    kStateHitTerminalVelocity,
    kStateMoving,
    kStateOffScreen,
    kStateHitSidesBounds
} CharacterStates;

// Debug Enemy States with Labels
// 0 for OFF, 1 for ON
#define ENEMY_STATE_DEBUG 0