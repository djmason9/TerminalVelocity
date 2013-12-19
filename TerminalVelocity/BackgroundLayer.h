//
//  BackgroundLayer.h
//  TerminalVelocity
//
//  Created by Aaron Jones on 6/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface BackgroundLayer : CCLayer {
    ccTime elapsedTime;
    BOOL isTransitioning;
    BOOL isTransitioningOut;
    CGSize screenSize;
    CCSpriteBatchNode *spriteBatchNode;
    BackgroundLayer *transitionLayer;
    ccTime transitionTime;
    NSUserDefaults *prefs;
}
@property(nonatomic, retain) BackgroundLayer *transitionLayer;

//-(BOOL)isHD;

-(void)updateScroll:(ccTime)deltaTime pos:(CGPoint)pos;
-(void)fadeInLayer;
-(void)fadeInLayer:(id)target selector:(SEL)selector;
-(void)fadeOutLayer;
-(void)objectsAchievmentIsComplete:(NSString*) achievementKey achievementTitle:(NSString *)title;
@end
