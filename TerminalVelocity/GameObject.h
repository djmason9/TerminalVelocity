//
//  GameObject.h
//  TerminalVelocity
//
//  Created by Aaron Jones on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"
#import "CommonProtocols.h"
#import "GameKitHelper.h"
#import "GameMusicManager.h"

@class GameObjectManager;

#define MAX_SECONDARY_OBJECT 20

@interface GameObject : CCSprite {
    id <GameplayLayerDelegate> delegate;
    BOOL isActive;
    SceneTypes sceneType;
    BOOL reactsToScreenBoundaries;
    CGSize screenSize;
    GameObjectType gameObjectType;
    NSUserDefaults *prefs;
    BOOL removeObject;
    GameObjectManager *gameObjectManager;
    CharacterStates characterState;
}
@property (readwrite) CharacterStates characterState;
@property (nonatomic, assign) id <GameplayLayerDelegate> delegate;
@property (nonatomic, retain) GameObjectManager *gameObjectManager;
@property (readwrite) BOOL isActive;
@property (readwrite) BOOL reactsToScreenBoundaries;
@property (readwrite) BOOL removeObject;
@property (readwrite) CGSize screenSize;
@property (readwrite) GameObjectType gameObjectType;
@property (readwrite) SceneTypes sceneType;

-(void)objectsAchievmentIsComplete:(NSString*) achievementKey achievementTitle:(NSString *)title;
-(BOOL)isObjectOffScreen;
-(void)changeState:(CharacterStates)newState; 
-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects; 
-(CGRect)adjustedBoundingBox;
-(CCAnimation *)loadPlistForAnimationWithName:(NSString*)animationName andClassName:(NSString*)className;
@end
