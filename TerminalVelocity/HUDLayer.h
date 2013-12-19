//
//  HUDLayer.h
//  TerminalVelocity
//
//  Created by Aaron Jones on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ActionButtonControl.h"
#import "Constants.h"
#import "CommonProtocols.h"
#import "GameObject.h"

@interface HUDLayer : CCLayer <GameplayLayerDelegate>{
    CCSpriteBatchNode *hudBatchNode;
    CCSprite *token1;
    CCSprite *token2;
    CCSprite *token3;
    
    BOOL isActionButtonPressed;
    
    @public
    CCLabelBMFont *terminalLabel;
    CCLabelBMFont *scoreLabel;
    CCLabelBMFont *mphLabel;
    ActionButtonControl *actionButton;
    ButtonControl *pauseButton;
    CCLayerColor *menuLayer;
    float zeroHeight;
    int numActionItems;
}
@property (nonatomic,readwrite) int numActionItems;
-(void)createHUD;
-(void)updateHUD:(ccTime)deltaTime pos:(CGPoint)pos;
-(void)showPausedMenu;
-(void)registerGameObjectTarget:(GameObject *)target action:(GameActionControl)action selector:(SEL)selector;

@end
