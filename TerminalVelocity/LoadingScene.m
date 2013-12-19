//
//  LoadingScene.m
//  TerminalVelocity
//
//  Created by Aaron Jones on 7/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoadingScene.h"

@implementation LoadingScene
@synthesize loadingScene;

- (void)dealloc {
    [[CCTextureCache sharedTextureCache] removeTextureForKey:@"menu_items.png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"menu_items.plist"];
    [loadingScene release];
    [super dealloc];
}

+(id)sceneWithTargetScene:(SceneTypes)targetScene; {
    return [[[self alloc] initWithTargetScene:targetScene] autorelease];
}

-(id) initWithTargetScene:(SceneTypes)target {
    if ((self = [super init]))
    {
        targetScene = target;
        
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        
        switch (target) {
            case kSpaceScene: {
                [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"menu_items.plist"];
                //spriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"menu_items.png"];
                CCSprite *backgroundImage = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"loading_bg.png"]];
                
                [backgroundImage setPosition:ccp(screenSize.width/2.0f, screenSize.height/2.0f)];
                [self  addChild:backgroundImage z:0 tag:0];
                
                CCLabelBMFont *label = [CCLabelBMFont labelWithString:@"Loading..." fntFile:@"menus.fnt"];
                CGSize size = [[CCDirector sharedDirector] winSize];
                label.position = CGPointMake(size.width / 2, size.height / 2);
                [self addChild:label];
                break;
            }
            case kSkyDayScene: {
                CCSprite *backgroundImage = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"loading_bg.png"]];
                [backgroundImage setPosition:ccp(screenSize.width/2.0f, screenSize.height/2.0f)];
                [self  addChild:backgroundImage z:0 tag:0];
                //CCSprite *borward = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"falling00001.png"]];
                
                break;
            }
            default:
                break;
        }
        [self scheduleUpdate];
    }
    
    return self;
}

-(void)update:(ccTime)delta {
    [self unscheduleAllSelectors];
    
    switch (targetScene) {
    
        case kSpaceScene: {
            //self.loadingScene = [SpaceGameScene node];
            self.loadingScene = [GameScene node];
            
            break;
        } case kSkyDayScene: {
            self.loadingScene = [GameScene node];
            break;
        } default:
            break;
    }
    
    if (loadingScene) {
        //[loadingScene loadGameObjects];
        [loadingScene transitionToScene:kSpaceScene];
        [[CCDirector sharedDirector] replaceScene:loadingScene];
    }
    
}

@end
