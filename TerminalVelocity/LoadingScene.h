//
//  LoadingScene.h
//  TerminalVelocity
//
//  Created by Aaron Jones on 7/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Constants.h"
#import "GameScene.h"

@interface LoadingScene : CCScene {
    SceneTypes targetScene;
    GameScene *loadingScene;
}
@property(nonatomic, retain) GameScene *loadingScene;
+(id) sceneWithTargetScene:(SceneTypes)targetScene;
-(id) initWithTargetScene:(SceneTypes)targetScene;
@end
