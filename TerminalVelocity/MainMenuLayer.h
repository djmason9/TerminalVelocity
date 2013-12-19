//
//  MainMenuLayer.h
//  TerminalVelocity
//
//  Created by Aaron Jones on 7/7/11.
//  Copyright (c) 2011 Dark Energy Studios. All rights reserved.
//



#import "cocos2d.h"
#import "ButtonControl.h"
#import "AppDelegate.h"
#import "MenuLayer.h"

@interface MainMenuLayer : MenuLayer <GameKitHelperProtocol,FBSessionDelegate>  {
    CCSprite *broward;
    CCLabelBMFont *objectiveLabel;
    CCLabelBMFont *volumnLabel;
    ButtonControl *volumnButton;
    
    AppDelegate *delegate; 
    
    CCSprite *difficult;
    
    UIViewController *tempVC;

}

-(void)addtabs:(int)currentTab;
-(void)setUpOptions;
@end
