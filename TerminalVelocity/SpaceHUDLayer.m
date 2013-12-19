//
//  SpaceHUDLayer.m
//  TerminalVelocity
//
//  Created by Aaron Jones on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SpaceHUDLayer.h"
#import "ButtonControl.h"

@implementation SpaceHUDLayer

- (void)dealloc {
    [token1 release];
    [token2 release];
    [token3 release];
    [super dealloc];
}

-(id)init {
    self = [super init];
    if (self) {

    }
    
    return self;
}

-(void)createHUD {
    [super createHUD];
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    // top banner
    //CCSprite *topBar = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"space_banner.png"]];
    //[hudBatchNode addChild:topBar];
    //[topBar setPosition:ccp(screenSize.width/2, screenSize.height-13)];
    
    // score font
    /*scoreLabel = [[CCLabelBMFont labelWithString:@"00000000" fntFile:@"space_scores.fnt"] retain];
    [self addChild:scoreLabel];
    [scoreLabel setAnchorPoint:ccp(0,0)];
    [scoreLabel setPosition:ccp(5, screenSize.height-16)];*/
    
    // action items
    token1 = [[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"jetpack.png"]] retain];
    [token1 setAnchorPoint:ccp(0, 0)];
    [hudBatchNode addChild:token1];
    [token1 setPosition:ccp(screenSize.width -24, screenSize.height - 24)];
    
    token2 = [[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"jetpack.png"]] retain];
    [token2 setAnchorPoint:ccp(0, 0)];
    [hudBatchNode addChild:token2];
    [token2 setPosition:ccp(screenSize.width -46, screenSize.height - 24)];
    
    token3 = [[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"jetpack.png"]] retain];
    [token3 setAnchorPoint:ccp(0, 0)];
    [hudBatchNode addChild:token3];
    [token3 setPosition:ccp(screenSize.width -68, screenSize.height - 24)];
   
    
    actionButton = [[ActionButtonControl buttonWithSpriteFrameName:@"jetpack_button.png" downFrameName:nil target:nil selectorStart:nil selectorEnd:nil] retain];
    actionButton.actionItemDelegate = self;
    [actionButton setIsTouchEnabled:YES];
    [actionButton setAnchorPoint:ccp(0, 0)];
    [self addChild:actionButton];
    [actionButton setPosition:ccp(screenSize.width-40,45)];
    
    
}

-(void)updateHUD:(ccTime)deltaTime pos:(CGPoint)pos {
    [super updateHUD:deltaTime pos:pos];
    
}

-(void) resetActionItems{
    token1.visible = YES;
    token2.visible = YES;
    token3.visible = YES;
    numActionItems=3;
}

-(int)getActionCount{
    return numActionItems;
}

-(void)decrementActionItem {
    
    if(numActionItems > 0)
        numActionItems--;
    
    if (token1.visible) {
        token1.visible = NO;
    } else if(token2.visible) {
        token2.visible = NO;
    } else if (token3.visible) {
        token3.visible = NO;
    }
}


@end
