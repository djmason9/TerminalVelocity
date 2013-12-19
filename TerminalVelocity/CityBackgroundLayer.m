//
//  CityBackgroundLayer.m
//  TerminalVelocity
//
//  Created by Aaron Jones on 9/3/11.
//  Copyright (c) 2011 Dark Energy Studios. All rights reserved.
//

#import "CityBackgroundLayer.h"
#import "GameManager.h"

@implementation CityBackgroundLayer
@synthesize gameplayLayer;
@synthesize scrollBrickWall;

- (void)dealloc {
    CCLOG(@"dealloc::CityGackgroundLayer");
    [backgroundImage release];
    [sideWalls1 release];
    [sideWalls2 release];
    [sideWallsTop release];
    [cityScape release];
    [crack release];
    //[manholeFront release];
    [brickWall release];
    [gameplayLayer release];
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        scrollBrickWall = NO;
        backgroundImage = [[CCLayerGradient layerWithColor:ccc4(183,215,229,255) fadingTo:ccc4(218,242,255,255) alongVector:ccp(0, -1)] retain];
        backgroundImage.position = ccp(0, 0);
        backgroundImage.opacity = 0;
        [self addChild:backgroundImage];
        
        spriteBatchNode = [[CCSpriteBatchNode batchNodeWithFile:@"city_items.png"] retain];
        [self addChild:spriteBatchNode];
        
        
        cityScape = [[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"city-background.png"]] retain];
        cityScape.position = ccp(screenSize.width/2, screenSize.height * -0.4);
        [spriteBatchNode addChild:cityScape];
        
        sideWalls1 = [[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"building_sides.png"]] retain];
        sideWalls1.position = ccp(screenSize.width/2, (screenSize.height/-2.0));
        [spriteBatchNode addChild:sideWalls1];
        
        sideWalls2 = [[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"building_sides.png"]] retain];
        sideWalls2.position = ccp(screenSize.width/2, (screenSize.height/-2.0f) - 480);
        [spriteBatchNode addChild:sideWalls2];
        
        sideWallsTop = [[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"building_sides_tops.png"]] retain];
        sideWallsTop.position = ccp(screenSize.width/2, 0);
        [spriteBatchNode addChild:sideWallsTop];
        
        brickWall = [[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"wall.png"]] retain];
        //brickWall.position = ccp(screenSize.width/2, (screenSize.height/-2.0));
        brickWall.position = ccp(screenSize.width/2, -204);
        brickWall.visible = NO;
        [spriteBatchNode addChild:brickWall];
        
        
        //crack = [[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"crack.png"]] retain];
        //crack.position = ccp(screenSize.width/2, (screenSize.height/-2.0) - 156);
        //crack.visible = NO;
        //[spriteBatchNode addChild:crack];
        
        //manholeFront = [[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"manhole-front.png"]] retain];
        //manholeFront.position = ccp(screenSize.width/2, (screenSize.height/-2.0) -202);
        //manholeFront.visible = NO;
         
    }
    return self;
}

-(void)setGameplayLayer:(CCLayer *)g {
    
    if (gameplayLayer != g) {
        id tmp = gameplayLayer;
        gameplayLayer = [g retain];
        [tmp release];
        
        //[gameplayLayer addChild:manholeFront z:101];
    }
    
}

-(void)updateScroll:(ccTime)deltaTime pos:(CGPoint)pos {
    transitionTime += deltaTime;
    
    if ([GameManager sharedGameManager].hasPlayerDied) {
        spriteBatchNode.visible = NO;
        //[manholeFront removeFromParentAndCleanup:YES];
        self.visible = NO;
        return;
    }
    
    if(!isTransitioningOut && transitionTime > TRANSTION_TIME_CITY){
        isTransitioningOut = YES;
        [[GameManager sharedGameManager] transitionToSceneWithID:kCaveScene];
        brickWall.visible = YES;
        
        
        //down To Earth complete the sky scene
        GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper]; 
        GKAchievement* achievement = [gkHelper getAchievementByID:@"downToEarth"];//downToEarth
        float percent = 100; 
        [gkHelper reportAchievementWithID:achievement.identifier percentComplete:percent];        
        
        [self objectsAchievmentIsComplete:achievement.identifier achievementTitle:@"Down To Earth"];
        
    }
    
    if (isTransitioningOut && scrollBrickWall) {
        //NSLog(@"here 1");
        float rate = 2000.0f / pos.y;
        brickWall.position = ccp(brickWall.position.x,brickWall.position.y + rate);
        //crack.position = ccp(crack.position.x,crack.position.y + rate);
        //manholeFront.position = ccp(manholeFront.position.x,manholeFront.position.y + rate);
    }
    
    if (sideWalls1.position.y < screenSize.height*0.5 && isTransitioning) {
        //NSLog(@"here 2");
        [transitionLayer updateScroll:deltaTime pos:pos];
        float rate = 2000.0f / pos.y;
        if (cityScape.position.y < screenSize.height * 0.4f) {
            cityScape.position = ccp(cityScape.position.x, cityScape.position.y + rate);
        }
        
        sideWalls1.position = ccp(sideWalls1.position.x, sideWalls1.position.y + rate);
        sideWalls2.position = ccp(sideWalls2.position.x, sideWalls2.position.y + rate);
        sideWallsTop.position = ccp(sideWallsTop.position.x, sideWallsTop.position.y + rate);
        
    } else if (transitionLayer != nil) {
        //NSLog(@"here 3");
        isTransitioning = NO;
        [sideWallsTop removeFromParentAndCleanup:YES];
        //backgroundImage.opacity = 255;
        
        id fadeIn = [CCFadeIn actionWithDuration:3.0f];
        [backgroundImage runAction:fadeIn];
        
        id fadeOut = [CCFadeOut actionWithDuration:3.0f];
        id remove = [CCCallBlockN actionWithBlock:^(CCNode *node) {
            [node removeFromParentAndCleanup:YES];
        }];
        [transitionLayer runAction:[CCSequence actions:fadeOut, remove, nil]];
        //[transitionLayer removeFromParentAndCleanup:YES];
        [transitionLayer release];
        transitionLayer = nil;
        //sideWalls1.position = ccp(sideWalls1.position.x, screenSize.height/2);
        //sideWalls2.position = ccp(sideWalls2.position.x, screenSize.height/2);
    }
    
   if (pos.y > 0 && !isTransitioning) {
        float rate = 2000.0f / pos.y;
        sideWalls1.position = ccp(sideWalls1.position.x, sideWalls1.position.y + rate);
        sideWalls2.position = ccp(sideWalls2.position.x, sideWalls2.position.y + rate);
    }
    
    if (sideWalls1.position.y  > 720) {
        [sideWalls1 setPosition:ccp(sideWalls2.position.x, sideWalls2.position.y - screenSize.height)];
    }
    if (sideWalls2.position.y  > 720) {
        [sideWalls2 setPosition:ccp(sideWalls1.position.x, sideWalls1.position.y - screenSize.height)];
    }
}

-(void)removeFromParentAndCleanup:(BOOL)cleanup {
    //[manholeFront removeFromParentAndCleanup:cleanup];
    [super removeFromParentAndCleanup:cleanup];
}

-(void)fadeInLayer {
    isTransitioning = YES;
    
}

@end
