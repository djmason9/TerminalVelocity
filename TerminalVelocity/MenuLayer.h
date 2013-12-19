//
//  MenuLayer.h
//  TerminalVelocity
//
//  Created by Darren Mason on 10/26/11.
//  Copyright (c) 2011 Dark Energy Studios. All rights reserved.
//

#import "cocos2d.h"
#import "ButtonControl.h"
#import "AppDelegate.h"
#import "GameKitHelper.h"

@interface MenuLayer : CCLayer
{
    CCLayer *mainMenuLayer;
    CCLayer *optionsMenuLayer;
    CCLayer *objectiveLayer;
    CCLayer *difficultyLayer;
    CCLayer *statsLayer;
    ButtonControl *statsButton;

    ButtonControl *easyTab,*normalTab,*hardTab;
    
    NSMutableArray *_scores;
    UITableView *tableView;
}

@end
