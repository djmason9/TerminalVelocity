//
//  GameObjectManager.h
//  TerminalVelocity
//
//  Created by Aaron Jones on 7/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "Box2DSprite.h"


@interface GameObjectManager : NSObject {
    CGSize screenSize;
    @public
    CCArray *objectList;
}
+(GameObjectManager *)sharedGameObjectManager;
-(Box2DSprite *)addGameObjectWtihType:(GameObjectType)type parentNode:(CCNode *)parentNode world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate;
-(void)addAsteroidsToNode:(CCNode *)parentNode world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate;
-(void)addAlienShip:(CCNode *)parentNode world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate;
-(void)removeGameObject:(CCNode *)node;
-(void)resetGameObject:(CCNode *)node;
-(void)removeAllGameObjects;
-(void)removeAllObjects;
-(void)addGargoyleToNode:(CCNode *)parentNode world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate;
-(void)addBirdToNode:(CCNode *)parentNode world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate;
-(void)addPigeonToNode:(CCNode *)parentNode world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate;
-(void)createObjectsForScene:(SceneTypes)type parentNode:(CCNode *)parentNode world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate;
-(void)addOwlToNode:(CCNode *)parentNode world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate;
-(void)addBatToNode:(CCNode *)parentNode withCount:(int)count world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate;
-(void)addPigToNode:(CCNode *)parentNode world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate;
-(void)addRocketToNode:(CCNode *)parentNode world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate;
-(void)addGlowBugToNode:(CCNode *)parentNode world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate;
-(void)addRootToNode:(CCNode *)parentNode world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate;
-(void)addBeesToNode:(CCNode *)parentNode world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate;
-(void)addLightningToNode:(CCNode *)parentNode world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate;
-(void)addReloadToNode:(CCNode *)parentNode world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate;
-(void)addReloadRocketToNode:(CCNode *)parentNode world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate;
-(void)addPlaneToNode:(CCNode *)parentNode world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate;
-(void)addBlimpToNode:(CCNode *)parentNode world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate;
-(void)addUmbrellaToNode:(CCNode *)parentNode world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate;
-(void)addBraToNode:(CCNode *)parentNode world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate;

-(void)setObjectsForRemoval;

@end
