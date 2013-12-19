//
//  GameManager.h
//  TerminalVelocity
//
//  Created by Aaron Jones on 6/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "GameObject.h"

@interface GameManager : NSObject {
    BOOL isMusicON;
    BOOL isSoundEffectsON;
    BOOL hasPlayerDied;
    BOOL isPaused;   
    BOOL isInstructions;
    int score;
    SceneTypes currentScene;
    SceneTypes transitionToScene;
    float difficultyLevel;
}
@property (readwrite) BOOL isMusicON;
@property (readwrite) BOOL isSoundEffectsON;
@property (readwrite) BOOL hasPlayerDied;
@property (readwrite) BOOL isPaused;
@property (readwrite) BOOL isInstructions;
@property (readwrite) int score;
@property (readwrite) float difficultyLevel;

+(GameManager*)sharedGameManager;
-(void)runSceneWithID:(SceneTypes)sceneID;
-(void)runSceneWithID:(SceneTypes)sceneID useLoadScene:(BOOL)userLoadScene;
-(void)transitionToSceneWithID:(SceneTypes)sceneID;
-(CGSize)getDimensionsOfCurrentScene;
-(void)pauseRunningScene;
-(void)registerGameObjectTarget:(GameObject *)target action:(GameActionControl)action selector:(SEL)selector;
@end
