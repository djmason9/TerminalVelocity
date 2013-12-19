//
//  BackgroundLayer.m
//  TerminalVelocity
//
//  Created by Aaron Jones on 6/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BackgroundLayer.h"
#import "GameMusicManager.h"
#import "GameKitHelper.h"
#import "GameManager.h"

@implementation BackgroundLayer
@synthesize transitionLayer;

-(void)dealloc {
    [spriteBatchNode release];
    [transitionLayer release];
    [super dealloc];
}


-(id)init {
    self = [super init];
    if (self != nil) {
        screenSize = [CCDirector sharedDirector].winSize;
        isTransitioning = NO;
        elapsedTime = 0.0f;        
    }
    
    return self;
    
}

-(void)updateScroll:(ccTime)deltaTime pos:(CGPoint)pos{
}

-(void)fadeInLayer:(id)target selector:(SEL)selector {
    isTransitioning = YES;
    id lastObj = [spriteBatchNode.children lastObject];
    
    CCSprite *s = nil;
    CCARRAY_FOREACH(spriteBatchNode.children, s) {
        [s setOpacity:0];
        id fadeInAction = [CCFadeIn actionWithDuration:1.0];
        
        
        if (s == lastObj) {
            id callDone = [CCCallFunc actionWithTarget:self selector:@selector(transitionDone)];
            id callback = [CCCallFunc actionWithTarget:target selector:selector];
            [s runAction:[CCSequence actions:fadeInAction, callback, callDone, nil]];
        } else {
            [s runAction:fadeInAction];
        }
    }
}

-(void)fadeInLayer {
    isTransitioning = YES;
    id lastObj = [spriteBatchNode.children lastObject];
    
    CCSprite *s = nil;
    CCARRAY_FOREACH(spriteBatchNode.children, s) {
        [s setOpacity:0];
        id fadeInAction = [CCFadeIn actionWithDuration:1.0];
        
        
        if (s == lastObj) {
            id callDone = [CCCallFunc actionWithTarget:self selector:@selector(transitionDone)];
            [s runAction:[CCSequence actions:fadeInAction, callDone, nil]];
        } else {
            [s runAction:fadeInAction];
        }
    }
}

-(void)transitionDone {
    isTransitioning = NO;
}

-(void)fadeOutDone {
    [self removeFromParentAndCleanup:YES];
}

-(void)fadeOutLayer {
    
    id lastObj = [spriteBatchNode.children lastObject];
    CCSprite *s = nil;
    CCARRAY_FOREACH(spriteBatchNode.children, s) {
        [s setOpacity:0];
        id fadeOutAction = [CCFadeOut actionWithDuration:1.0];
        //[s runAction:fadeInAction];
        if (s == lastObj) {
            id callDone = [CCCallFunc actionWithTarget:self selector:@selector(fadeOutDone)];
            [s runAction:[CCSequence actions:fadeOutAction, callDone, nil]];
        } else {
            [s runAction:fadeOutAction];
        }
    }
}

-(void)objectsAchievmentIsComplete:(NSString*) achievementKey achievementTitle:(NSString *)title{
    
    NSString *sysVer = [[UIDevice currentDevice] systemVersion];
    float sysVerFloat = [sysVer floatValue];
    
    GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper]; 
    
    NSString *userKey = [prefs stringForKey:achievementKey];
    
    GKAchievement* achievement = [gkHelper getAchievementByID:achievementKey];
    
    if (achievement.completed && ![userKey isEqualToString:@"true"]) 
    {
        if (sysVerFloat >= 5.0) 
            achievement.showsCompletionBanner =YES;
        else
        {
            CGSize size = [CCDirector sharedDirector].winSize;
            NSString *achievmentString = [NSString stringWithFormat:@"+100 %@ Complete",title];
            
            CCLabelBMFont *scoreLabel = [CCLabelBMFont labelWithString:achievmentString fntFile:@"menus.fnt"];
            scoreLabel.position = ccp(size.width *.5, size.height *.5);
            [self.parent.parent addChild:scoreLabel];
            
            id fadeOut = [CCFadeOut actionWithDuration:2.5f];
            id remove = [CCCallBlockN actionWithBlock:^(CCNode *node){
                //CCLOG(@"REMOVE ALIEN SCORE LABEL");
                [node removeFromParentAndCleanup:YES];
            }];
            [scoreLabel runAction:[CCSequence actions:fadeOut, remove, nil]];
        }
        
        [prefs setObject:@"true" forKey:achievementKey];
        [GameManager sharedGameManager].score += 100;
        
    }else if (sysVerFloat >= 5.0) 
        achievement.showsCompletionBanner=NO;
    
}

@end
