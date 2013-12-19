//
//  SpaceBackgroundLayer.m
//  TerminalVelocity
//
//  Created by Aaron Jones on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SpaceBackgroundLayer.h"
#import "GameManager.h"
#import "HUDLayer.h"
#import "GameMusicManager.h"


@implementation SpaceBackgroundLayer
-(void)dealloc {
    [[CCTextureCache sharedTextureCache] removeTextureForKey:@"space_scene_items.png"];
    [[CCTextureCache sharedTextureCache] removeTextureForKey:@"earth.png"];
    [[CCTextureCache sharedTextureCache] removeTextureForKey:@"particleAsteriodExplode.png"];
    [[CCTextureCache sharedTextureCache] removeTextureForKey:@"particleTextureComet.png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"space_scene_items.plist"];
    //[spriteBatchNode removeFromParentAndCleanup:YES];
    //[spriteBatchNode removeAllChildrenWithCleanup:YES];
    
    [movingStars1 release];
    [movingStars2 release];
    [moonImage release];
    [earthImage release];
    
    [super dealloc];
}

-(id)init {
    self = [super init];
    if (self) {
        
        //CGSize screenSize = [[CCDirector sharedDirector] winSize];
        CCSprite *starsImage;
        spriteBatchNode = [[CCSpriteBatchNode batchNodeWithFile:@"space_scene_items.png"] retain];
        [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"comet.plist"];
        starsImage = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"star_field.png"]];        

        
        // black background
       // CCLayerColor *layer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 0)];
        //[self addChild:layer z:0 tag:0];// THIS IS WHAT WAS CAUSING A ACCELEROMETER GLITCH
        [self addChild:spriteBatchNode];
        
        // static stars field
        [starsImage setPosition:CGPointMake(screenSize.width/2.0f, screenSize.height/2.0f)];
        [spriteBatchNode addChild:starsImage];
        
        // moving Stars field
        movingStars1 = [[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"star_field2.png"]] retain];
        movingStars2 = [[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"star_field2.png"]] retain];
        
        movingStars1.position = ccp(screenSize.width / 2.0f, (screenSize.height / 2.0f));
        movingStars2.position = ccp(screenSize.width / 2.0f, (screenSize.height / -2.0f));
        
        movingStars1.position =  ccp(screenSize.width / 2.0f, (screenSize.height / 2.0f));
        movingStars2.position = ccp(screenSize.width / 2.0f, (screenSize.height / -2.0f));
        
        [spriteBatchNode addChild:movingStars1];
        [spriteBatchNode addChild:movingStars2];
        
        //MOON
        moonImage = [[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"moon.png"]] retain];
        [moonImage setPosition:ccp(screenSize.width*0.3f, screenSize.height*0.55f)];
        [spriteBatchNode addChild:moonImage];
        
        
        
        // EARTH
        isCentered = false;
        earthImage = [[CCSprite spriteWithFile:@"earth.png"] retain];
        [earthImage  setScale:0.2f];
        [earthImage setPosition:ccp(screenSize.width * .93f, screenSize.height*0.5f)];
        [self addChild:earthImage];
        
        //////////////////// FIRST TIME INSTRUCTIONS //////////////////////
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if(![defaults objectForKey:@"notANoob"] ){
            
            instructionsLayer = [[CCLayer alloc]init];
            //suffixText=@"";
            //if ( [self isHD] ) suffixText = @"-hd";
            
            CCSprite *instructions = [CCSprite spriteWithFile:@"instructions.png"];
            
            [instructions setPosition:ccp(screenSize.width*.5, screenSize.height*.5)];
            [instructionsLayer addChild:instructions];
            /*
            [[CCDirector sharedDirector] pause];
            [GameManager sharedGameManager].isPaused = YES;
            [GameManager sharedGameManager].isInstructions =YES;
            */
            //instructions button
            ButtonControl *okIgotItButton = [ButtonControl buttonWithSpriteFrameName:@"placard.png" downFrameName:@"placard_on.png" target:self selectorStart:nil  selectorEnd:@selector(okIgotItButtonPressed:)];
            
            [okIgotItButton setIsTouchEnabled:YES];
            
            okIgotItButton.anchorPoint = ccp(0.5,0.5);
            okIgotItButton.position = ccp(screenSize.width*.5f, screenSize.height * 0.11f);
            [instructionsLayer addChild:okIgotItButton];
            
            CGSize box = okIgotItButton.boundingBox.size;
            CCLabelBMFont *instructionsLabel = [CCLabelBMFont labelWithString:@"Ok I Got it!" fntFile:@"menus.fnt"];
            instructionsLabel.position = [okIgotItButton convertToWorldSpace:ccp(box.width *0.5f, box.height*0.5f)];
            
            [instructionsLayer addChild:instructionsLabel];
            
            [self addChild:instructionsLayer];

            [instructionsLayer setScale:0.0];
            
            id animateInstuctions = [CCCallBlockN actionWithBlock:^(CCNode *node) {
               
                CCScaleTo *big = [CCScaleTo actionWithDuration:.2f scale:1.2f];
                CCScaleTo *medium = [CCScaleTo actionWithDuration:.05f scale:1.0f];
                
                //Wrap up the three actions in a CCSequence
                CCSequence *sequence = [CCSequence actions:big, medium, nil];
                
                id stopAllAction = [CCCallBlockN actionWithBlock:^(CCNode *node) {
                    
                    [[CCDirector sharedDirector] pause];
                    [GameManager sharedGameManager].isPaused = YES;
                    [GameManager sharedGameManager].isInstructions =YES;
                    
                }];

                
                
                [instructionsLayer runAction:[CCSequence actions: sequence,stopAllAction, nil]];
                
            }];
                       
            [instructionsLayer runAction:animateInstuctions];
            
        }
        
    }
    return self;
}

-(void)okIgotItButtonPressed:(id)sender{

    [self removeChild:instructionsLayer cleanup:YES];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
    [defaults setObject:@"true" forKey:@"notANoob"];
    [defaults synchronize];
    
     [GameManager sharedGameManager].isPaused = NO;
    [GameManager sharedGameManager].isInstructions =NO;
    [[CCDirector sharedDirector] resume];
    [instructionsLayer release];
}

-(void)addComet {
    
    float randomNum = arc4random_uniform(100) * 0.01f;
    CCParticleSystem *comet = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"comet.plist"];
    if(randomNum >= 0.40 && randomNum <= 0.80)
    {
        [comet setPosition:ccp(-10, screenSize.height * randomNum)];
        [comet setScale:0.8f];
        [self addChild:comet];
        
        id moveComet = [CCMoveTo actionWithDuration:3.0f position:ccp(screenSize.width + 300, screenSize.height * 0.30f)];
        id removeNode = [CCCallBlockN actionWithBlock:^(CCNode *node) {
            CCParticleSystem *ps = (CCParticleSystem *)node;
            //[ps resetSystem];
            [ps removeFromParentAndCleanup:YES];
            //CCLOG(@"REMOVING COMET PARTICLE");
        }];
        
        [comet runAction:[CCSequence actions:moveComet, removeNode, nil]];
    }
    
}

-(void)deathAnimation {
    spriteBatchNode.visible = NO;
    earthImage.visible = NO;
}


-(void)updateScroll:(ccTime)deltaTime pos:(CGPoint)pos {
    //[super updateScroll:deltaTime pos:pos];
    
    if ([GameManager sharedGameManager].hasPlayerDied) {
        [self deathAnimation];
        return;
    }
    
    if(earthImage.scale > 1.3f){ // 1.3
        
        if (!isTransitioningOut) {
            isTransitioningOut = YES;
            HUDLayer *hud = (HUDLayer *)[self.parent getChildByTag:kSPACE_HUD_LAYER_TAG];
            hud->actionButton.isTouchEnabled = NO;
            [[GameManager sharedGameManager] transitionToSceneWithID:kSkyDayScene];
            //[[GameManager sharedGameManager] transitionToSceneWithID:kCaveScene];
            id zoomEarth = [CCScaleTo actionWithDuration:1.0f scale:5.0f];
            [earthImage runAction:zoomEarth];
            
            //space scene complete the rain scene
            GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper]; 
            GKAchievement* achievement = [gkHelper getAchievementByID:@"spaceComplete"];//spaceComplete
            float percent = 100; 
            [gkHelper reportAchievementWithID:achievement.identifier percentComplete:percent];        
            
            [self objectsAchievmentIsComplete:achievement.identifier achievementTitle:@"Space Race"];
        }
        
        return;
    }
    
    static float cometInterval = 0.0f;
    cometInterval += deltaTime;
    
    if (cometInterval >= 4.0f && earthImage.scale < 0.8f) {
        [self addComet];
        cometInterval = 0.0f;
    }
    
    if (pos.y > 0) {
        float rate = 1000.0f / pos.y; // old value of 1000.0
        float earthRate = 3.5f;//made this a constant rate to fix earth from blowing up to fast
        //NSLog(@"RATE %f",rate);
        movingStars1.position = ccp(movingStars1.position.x, movingStars1.position.y + rate);
        movingStars2.position = ccp(movingStars2.position.x, movingStars2.position.y + rate);
        moonImage.position = ccp(moonImage.position.x + (0.005 *earthRate), moonImage.position.y + (0.003 *earthRate));
        
        //once the earth is centered keep it there and start raising it up
        
        float X_axis = earthImage.position.x + (-0.006f * earthRate);
        float Y_axisDown = earthImage.position.y + (-0.01f * earthRate);
        float Y_axisUp = earthImage.position.y + (0.008f * earthRate);
        
       if( X_axis <= screenSize.width/2)
           isCentered = true;
    
        earthImage.position = ccp((X_axis >= screenSize.width/2? X_axis:screenSize.width/2), (isCentered ? Y_axisUp:Y_axisDown));
        [earthImage setScale:earthImage.scale + (SPACE_SCENE_RATE * earthRate) + (isCentered? 0.00015:0)];//once the earth is centered make it grow faster old 0.00001f
        //CCLOG(@"SCALE:%f",earthImage.scale);
        //CCLOG(@"X AXIS:%f",earthImage.position.x);
    }
    
    
    if (movingStars1.position.y  > 720) {
        [movingStars1 setPosition:ccp(movingStars2.position.x, movingStars2.position.y - screenSize.height)];
        [movingStars1 setRotation:180.0f];
    }
    if (movingStars2.position.y  > 720) {
        [movingStars2 setPosition:ccp(movingStars1.position.x, movingStars1.position.y - screenSize.height)];
        [movingStars2 setRotation:180.0f];
    }

}


@end
