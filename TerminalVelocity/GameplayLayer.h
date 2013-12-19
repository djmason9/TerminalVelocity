//
//  GameplayLayer.h
//  TerminalVelocity
//
//  Created by Aaron Jones on 6/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "Broward.h"
#import "BackgroundLayer.h"
#import "HUDLayer.h"
#import "AccelerometerFilter.h"
#import "GameObjectManager.h"
#import "CommonProtocols.h"
#import "GameOverLayer.h"
#import "Constants.h"

@interface GameplayLayer : CCLayer {
    
    b2Body *browardBody;
    CGSize screenSize;
    
    // Box2D
    b2World *world;
    b2Body *boundsBody;
	GLESDebugDraw *debugDraw;
    
    HUDLayer *hudLayer;
    BackgroundLayer *backgroundLayer;
    GameOverLayer *gameOverLayer;
    
    @public
    Broward *broward;
    GameObjectManager *objectManager;
    CCSpriteBatchNode *browardSpriteBatchNode;
    CCSpriteBatchNode *collisionObjectsSpriteBatchNode;
    float totalTime;
    
    
    AccelerometerFilter *filterLow;
    AccelerometerFilter *filterHigh;
    
    float zeroHeight;
}
@property(nonatomic, retain) HUDLayer *hudLayer;
@property(nonatomic, retain) BackgroundLayer *backgroundLayer;
@property(nonatomic, retain) GameOverLayer *gameOverLayer;
-(void)update:(ccTime)deltaTime;
-(void)loadGameObjects;
-(void)loadGameObjectsForScene:(SceneTypes)type;
-(void)transitionToScene:(SceneTypes)type;
-(void)transitionToScene:(SceneTypes)type backgroundLayer:(BackgroundLayer *)background hudLayer:(HUDLayer *)hud;
-(void)addGameObjectsForSky;
@end
