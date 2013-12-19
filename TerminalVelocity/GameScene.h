//
//  GameScene.h
//  TerminalVelocity
//
//  Created by Aaron Jones on 6/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"

@class BackgroundLayer;
@class HUDLayer;

@class GameplayLayer;

@interface GameScene : CCScene {
    SceneTypes sceneType;
    GameplayLayer *gameplayLayer;
    
}
@property(readonly) SceneTypes sceneType;

-(void)transitionToScene:(SceneTypes)type;
@end
