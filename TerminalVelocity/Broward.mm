//
//  Broward.m
//  TerminalVelocity
//
//  Created by Aaron Jones on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Broward.h"
#import "Box2DHelpers.h"
#import "GameManager.h"
#import "GameMusicManager.h"

@implementation Broward
@synthesize fallingAnim;
@synthesize burningAnim;
@synthesize beeAttackAnim;
@synthesize bounceAnim;
@synthesize bounceSkyAnim;
@synthesize jetpackRepeatAnim;
@synthesize parachuteOnceAnim;
@synthesize parachuteRepeatAnim;
@synthesize fallingSkyAnim;
@synthesize removedSpaceSuit;

@synthesize nightParachuteRepeatAnim;
@synthesize nightParachuteOnceAnim;
@synthesize nightFallingSkyAnim;
@synthesize nightBounceSkyAnim;


-(void)dealloc {
    [fallingAnim release];
    [fallingSkyAnim release];
    [burningAnim release];
    [beeAttackAnim release];
    [bounceAnim release];
    [jetpackRepeatAnim release];
    [parachuteOnceAnim release];
    [parachuteRepeatAnim release];
    [bounceSkyAnim release];
    [removedSpaceSuit release];
    [super dealloc];
}

-(void)setParent:(CCNode *)node {
    [super setParent:node];
    [node.parent addChild:smokingEmitter];
}

-(void)setPosition:(CGPoint)p {
    [super setPosition:p];
    smokingEmitter.position = p;

}

-(id)initWithWorld:(b2World *)world atLocation:(CGPoint)location {
    self = [super initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"space_falling00001.png"]];

    if (self) {
        //mirroredSprite = [[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"space_falling00001.png"]] retain];
        removedSpaceSuit = [[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"space_suit_transition00025.png"]] retain];
        removedSpaceSuit.visible = NO;
        //mirroredSprite.visible = NO;
        
        [self setPosition:location];
        // Define the dynamic body.
        //Set up a 1m squared box in the physics world
        b2BodyDef bodyDef;
        bodyDef.type = b2_dynamicBody;
        //CGRect r = broward.textureRect;
        bodyDef.position.Set(location.x/PTM_RATIO, location.y/PTM_RATIO);
        bodyDef.userData = self;
        bodyDef.fixedRotation = true;
        body = world->CreateBody(&bodyDef);
        
        //bodyDef.userData = mirroredSprite;
        //bodyDef.position.Set(location.x/PTM_RATIO, (location.y + 50)/PTM_RATIO);
        //mirroredBody = world->CreateBody(&bodyDef);
        //mirroredBody->SetActive(false);
        
        // Define another box shape for our dynamic body.
        b2PolygonShape dynamicBox;
        int num = 7;
        b2Vec2 verts[] = {
            b2Vec2(53.0f / VECTOR_PTM_RATIO, 17.0f / VECTOR_PTM_RATIO),
            b2Vec2(9.0f / VECTOR_PTM_RATIO, 30.0f / VECTOR_PTM_RATIO),
            b2Vec2(-64.0f / VECTOR_PTM_RATIO, -19.0f / VECTOR_PTM_RATIO),
            b2Vec2(-73.0f / VECTOR_PTM_RATIO, -68.0f / VECTOR_PTM_RATIO),
            b2Vec2(-46.0f / VECTOR_PTM_RATIO, -86.0f / VECTOR_PTM_RATIO),
            b2Vec2(48.0f / VECTOR_PTM_RATIO, -72.0f / VECTOR_PTM_RATIO),
            b2Vec2(53.0f / VECTOR_PTM_RATIO, 14.0f / VECTOR_PTM_RATIO)
        };
             
        dynamicBox.Set(verts, num);
        
        // Define the dynamic body fixture.
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &dynamicBox;	
        fixtureDef.density = 1.0f;
        fixtureDef.friction = 0.0f;
        fixtureDef.restitution = 0.0f;
        //fixtureDef.isSensor = true;
        body->CreateFixture(&fixtureDef);
        //mirroredBody->CreateFixture(&fixtureDef);
        [self startFallingAnim];
        
    }
    return self;
}

-(id)init {
    self = [super init];
    if (self) {
        actionTime = 2.0f;
        //time = 0;
        [delegate resetActionItems];
        
        sceneType = kSpaceScene;
        [self setGameObjectType:kBroward];
        smokingEmitter = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"smoke.plist"];
        [smokingEmitter setScale:0.5f];
        [smokingEmitter stopSystem];
        
        [self setFallingAnim:[self loadPlistForAnimationWithName:@"FallingAnim" andClassName:@"BrowardSpace"]];
        //[self setBurningAnim:[self loadPlistForAnimationWithName:@"BurningAnim" andClassName:@"BrowardSpace"]];
        [self setBounceAnim:[self loadPlistForAnimationWithName:@"BounceAnim" andClassName:@"BrowardSpace"]];
        [self setJetpackRepeatAnim:[self loadPlistForAnimationWithName:@"JetpackRepeat" andClassName:@"BrowardSpace"]];
        [self setParachuteOnceAnim:[self loadPlistForAnimationWithName:@"ParachuteOnceAnim" andClassName:@"BrowardSky"]];
        [self setParachuteRepeatAnim:[self loadPlistForAnimationWithName:@"ParachuteRepeatAnim" andClassName:@"BrowardSky"]];
        [self setFallingSkyAnim:[self loadPlistForAnimationWithName:@"FallingAnim" andClassName:@"BrowardSky"]];
        [self setBounceSkyAnim:[self loadPlistForAnimationWithName:@"BounceAnim" andClassName:@"BrowardSky"]];
        //night
        [self setNightParachuteOnceAnim:[self loadPlistForAnimationWithName:@"ParachuteOnceAnim" andClassName:@"BrowardNight"]];
        [self setNightParachuteRepeatAnim:[self loadPlistForAnimationWithName:@"ParachuteRepeatAnim" andClassName:@"BrowardNight"]];
        [self setNightFallingSkyAnim:[self loadPlistForAnimationWithName:@"FallingAnim" andClassName:@"BrowardNight"]];
        [self setNightBounceSkyAnim:[self loadPlistForAnimationWithName:@"BounceAnim" andClassName:@"BrowardNight"]];
        

    }
    return self;
}


-(void)removeSpaceSuitAnim {
    sceneType = kSkyDayScene;
    [self startFallingAnim];
    PLAYSOUNDEFFECT(SPACESUIT_OFF);
    removedSpaceSuit.visible = YES;
    removedSpaceSuit.position = ccp(self.position.x, self.position.y + 50)
    ;
    [self.parent addChild:removedSpaceSuit];
    
    id moveUp = [CCMoveTo actionWithDuration:1.0f position:ccp(screenSize.width/2.0f, screenSize.height + 150)];
    [removedSpaceSuit runAction:moveUp];
}

-(void)animateBounceWithForce:(float)force {
    [self stopAllActions];
    
    id a1 = nil;
    id a2 = nil;
    switch (sceneType) {
        case kSpaceScene: {
            a1 = [CCAnimate actionWithAnimation:bounceAnim];
            a2 = [CCCallBlockN actionWithBlock:^(CCNode *node) {
                [node runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:fallingAnim]]];
                characterState = kStateFalling;
            }];
            break;
        }
        case kSkyDayScene: {
            a1 = [CCAnimate actionWithAnimation:bounceSkyAnim];
            a2 = [CCCallBlockN actionWithBlock:^(CCNode *node) {
                [node runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:fallingSkyAnim]]];
                characterState = kStateFalling;
            }];
            break;
        }
        case kSkyNightScene: {
            a1 = [CCAnimate actionWithAnimation:nightBounceSkyAnim];
            a2 = [CCCallBlockN actionWithBlock:^(CCNode *node) {
                [node runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:nightFallingSkyAnim]]];
                characterState = kStateFalling;
            }];
            break;
        }

        default:
            break;
    }
    
   

    [self runAction:[CCSequence actions:a1, a2, nil]];

    static b2Vec2 zeroVel;
    b2Vec2 origVel = body->GetLinearVelocity();
    zeroVel.Set(origVel.x, force);
    body->SetLinearVelocity(zeroVel);
  
}

-(void)changeState:(CharacterStates)newState {
    
    [self setCharacterState:newState];
	
	switch (newState) {
        case kStateHitSmallObject: {
            [self animateBounceWithForce:(0.64f + [GameManager sharedGameManager].difficultyLevel)];
            break;
        }
        case kStateHitLargeObject: {
            [self animateBounceWithForce:(0.98f + [GameManager sharedGameManager].difficultyLevel)];
            break;
        }
        case kStateDead: {
            body->SetActive(false);
            break;
        }
        case kStateHitTerminalVelocity: {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            characterState = kStateDead;
            [GameManager sharedGameManager].hasPlayerDied = YES;
            body->SetActive(false);
            
            CCSprite *browardBurn = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"death-space00074.png"]];
            
            browardBurn.position = ccp(screenSize.width/2, screenSize.height);
            [self.parent.parent addChild:browardBurn];
            self.visible = NO;
            //mirroredSprite.visible = NO;
            CCParticleSystem *smoke = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"flame.plist"];
            [smoke setAutoRemoveOnFinish:YES];
            smoke.position = ccp(screenSize.width/2, screenSize.height);
            [self.parent.parent addChild:smoke];
           // id moveToTop = [CCMoveTo actionWithDuration:0.5f position:ccp(screenSize.width/2, screenSize.height)];
            id moveToBottom = [CCMoveTo actionWithDuration:2.0f position:ccp(screenSize.width/2, -500)];
            
            id anim = nil;
            
            switch (sceneType) {
                case kSpaceScene:
                    anim = [CCAnimate actionWithAnimation:[self loadPlistForAnimationWithName:@"BurningAnim" andClassName:@"BrowardSpace"]];
                    break;
                case kSkyDayScene:
                    anim = [CCAnimate actionWithAnimation:[self loadPlistForAnimationWithName:@"BurningAnim" andClassName:@"BrowardSky"]];
                    break;
                case kSkyNightScene:
                    anim = [CCAnimate actionWithAnimation:[self loadPlistForAnimationWithName:@"BurningAnim" andClassName:@"BrowardSky"]];
                    break;
                default:
                    break;
            }
            
            [browardBurn runAction:[CCSequence actions:moveToBottom, nil]];
            
            //id flameMoveToTop = [CCMoveTo actionWithDuration:0.5f position:ccp(screenSize.width/2, screenSize.height -20)];
            [smoke runAction:[CCSequence actions:[moveToBottom copy], nil]];
            [browardBurn runAction:[CCRepeatForever actionWithAction:anim]];
            break;
        }
        default:
            break;
    }
}



-(void)startFallingAnim {
    characterState = kStateFalling;
    
    id animateAction = nil;
    
    switch (sceneType) {
        case kSpaceScene:{
            animateAction = [CCAnimate actionWithAnimation:fallingAnim];
            break;
        }
        case kSkyDayScene:{
            animateAction = [CCAnimate actionWithAnimation:fallingSkyAnim];
            break;
        }
        case kSkyNightScene:{
            animateAction = [CCAnimate actionWithAnimation:nightFallingSkyAnim];
            break;
        }
        default:
            break;
    }
    
    
    CCAction *repeatAction = [CCRepeatForever actionWithAction:animateAction];
    repeatAction.tag = 100;
    [self runAction:repeatAction];
}

-(void)startActionButtonAction {
    [self stopAllActions];
    
    switch (sceneType) {
        case kSpaceScene:{
            [self runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:jetpackRepeatAnim]]];
            break;
        }
        case kSkyDayScene: {
            id once = [CCAnimate actionWithAnimation:parachuteOnceAnim];
            id callRepeat = [CCCallBlockN actionWithBlock:^(CCNode *node) {
                [node runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:parachuteRepeatAnim]]];
                characterState = kStateFalling;
            }];
            [self runAction:[CCSequence actions:once, callRepeat, nil]];
            break;
        }
        case kSkyNightScene: {
            id once = [CCAnimate actionWithAnimation:nightParachuteOnceAnim];
            id callRepeat = [CCCallBlockN actionWithBlock:^(CCNode *node) {
                [node runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:nightParachuteRepeatAnim]]];
                characterState = kStateFalling;
            }];
            [self runAction:[CCSequence actions:once, callRepeat, nil]];
            break;
        }
            
        default:
            break;
    }
    
    
    id moveTo = [CCMoveTo actionWithDuration:1 position:ccp(screenSize.width/2, screenSize.height -50)];
    id stopFunc = [CCCallFunc actionWithTarget:self selector:@selector(stopActionButtonAction)];
    
    [self runAction:[CCSequence actions:moveTo, stopFunc, nil]];
    
    body->SetLinearVelocity(b2Vec2_zero);
    
    b2Vec2 newPos;
    newPos.Set((screenSize.width/2)/PTM_RATIO, (screenSize.height -50)/PTM_RATIO);
    body->SetTransform(newPos, 0);
}
static BOOL actionStarted = NO;
-(void)stopActionButtonAction {
    
    body->SetActive(true);
    characterState = kStateFalling;
    [self stopAllActions];
    [self startFallingAnim];
    actionStarted = NO;
}

-(void)checkAndClampSpritePosition {
    CGPoint currentSpritePosition = [self position];
    static CGSize levelSize = [[GameManager sharedGameManager] getDimensionsOfCurrentScene];
    CGSize box = self.boundingBox.size;
    static float xOffset = -1*box.width/2;
    static float xOffsetRight = levelSize.width - xOffset;
    static b2Vec2 newPos;
    
    if (currentSpritePosition.x < xOffset && body->IsActive()) {
        b2Vec2 origPos = body->GetPosition();
        newPos.Set(xOffsetRight/PTM_RATIO, origPos.y);
        body->SetTransform(newPos, 0);
        [smokingEmitter stopSystem];
    } else if (currentSpritePosition.x > xOffsetRight && body->IsActive()) {
        b2Vec2 origPos = body->GetPosition();
        newPos.Set(xOffset/PTM_RATIO, origPos.y);
        body->SetTransform(newPos, 0);
        [smokingEmitter stopSystem];
    }
}


-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects {
    
    if ([GameManager sharedGameManager].hasPlayerDied) {
        return;
    }
    [self checkAndClampSpritePosition];
    
    if (characterState == kStateActionButtonPressed) {
        
        if (!actionStarted) {
            
            actionStarted = YES;
            [self startActionButtonAction];
        }
    } else if (isBodyCollidingWithObjectType(body, kSmallObject)) {
        [self changeState:kStateHitSmallObject]; 
    //} else if (isBodyCollidingWithObjectType(body, kMediumObject)) {
        //[self changeState:kStateHitMediumObject];
    } else if (isBodyCollidingWithObjectType(body, kLargeObject)) {
        [self changeState:kStateHitLargeObject];
    } else if (isBodyCollidingWithObjectType(body, kKillObject)) {
        [self changeState:kStateDead]; 
    } else if (self.position.y < 0) {
        [self changeState:kStateHitTerminalVelocity];
    }
    
    
    
    if (self.position.y <= screenSize.height * 0.55f && self.position.y >= 0 && characterState != kStateActionButtonPressed) {
        if (!smokingEmitter.active) {
            [smokingEmitter resetSystem];
        }
    } else if (smokingEmitter.active) {
        [smokingEmitter stopSystem];
    }   
        
}

-(void)setDelegate:(id<GameplayLayerDelegate>)del {
    delegate = del;
    [delegate resetActionItems];
    [delegate registerGameObjectTarget:self action:kActionControlButton selector:@selector(actionButtonPressed)];
}

-(void)actionButtonPressed {
    
    if(![GameManager sharedGameManager].isPaused )
    {
        switch (sceneType) {
            case kSpaceScene:{
                if (characterState != kStateActionButtonPressed && characterState == kStateFalling && [delegate getActionCount] > 0) {
                    //play sound
                    PLAYSOUNDEFFECT(JET_PACK);
                    body->SetActive(false);
                    characterState = kStateActionButtonPressed;
                    [delegate decrementActionItem];
                    CCParticleSystem *ring = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"ring_particle.plist"];
                    [ring setScale:0.6];
                    [self.parent.parent addChild:ring];
                    ring.position = ccp(self.position.x - 15, self.position.y);
                    //ring.duration = 0.5;
                    ring.autoRemoveOnFinish = YES;
                    //[ring resetSystem];
                }
                break;
            }
            default:
            {
                //NSLog(@"[delegate getActionCount]: %i",[delegate getActionCount]);
                if (characterState != kStateActionButtonPressed &&  characterState == kStateFalling &&  [delegate getActionCount] > 0) {
                    //play sound
                    PLAYSOUNDEFFECT(PARACHUTE);
                    body->SetActive(false);
                    characterState = kStateActionButtonPressed;
                    [delegate decrementActionItem];
                }
                break;
            }
              
        }
    }
}

@end

/*
@implementation BrowardSky

-(id)init {
    self = [super init];
    if (self) {
        [self setFallingAnim:[self loadPlistForAnimationWithName:@"FallingAnim" andClassName:NSStringFromClass([self class])]];
        [self setBurningAnim:[self loadPlistForAnimationWithName:@"BurningAnim" andClassName:NSStringFromClass([self class])]];
        [self setBeeAttackAnim:[self loadPlistForAnimationWithName:@"BeeAttackAnim" andClassName:NSStringFromClass([self class])]];
        [self setBounceAnim:[self loadPlistForAnimationWithName:@"BounceAnim" andClassName:NSStringFromClass([self class])]];
        [self setActionButtonAnim:[self loadPlistForAnimationWithName:@"ParachuteAnim" andClassName:NSStringFromClass([self class])]];
        //[self startFallingAnim];
        
    }
    return self;
}

-(void)setDelegate:(id<GameplayLayerDelegate>)del {
    delegate = del;
    [delegate registerGameObjectTarget:self action:kActionControlButton selector:@selector(parachuteActionPressed)];
}

-(void)parachuteActionPressed {
    
   
    if (characterState != kStateActionButtonPressed &&  characterState == kStateFalling && numActionItems > 0) {
         [[SimpleAudioEngine sharedEngine] playEffect:@"parachutedeploy.caf" pitch:1.0f pan:0.0f gain:1.2f];
        body->SetActive(false);
        characterState = kStateActionButtonPressed;
        numActionItems--;
    }
}

@end

@implementation BrowardSpace

- (void)dealloc {
    [super dealloc];
}
-(id)init {
    self = [super init];
    if (self) {
        [self setFallingAnim:[self loadPlistForAnimationWithName:@"FallingAnim" andClassName:NSStringFromClass([self class])]];
        //[self setBurningAnim:[self loadPlistForAnimationWithName:@"BurningAnim" andClassName:NSStringFromClass([self class])]];
        [self setBounceAnim:[self loadPlistForAnimationWithName:@"BounceAnim" andClassName:NSStringFromClass([self class])]];
        [self setActionButtonAnim:[self loadPlistForAnimationWithName:@"JetpackRepeat" andClassName:NSStringFromClass([self class])]];
    }
    return self;
}



-(void)jetpackActionPressed {
    
    if (characterState != kStateActionButtonPressed && characterState == kStateFalling && numActionItems > 0) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"jetpack.caf" pitch:1.0f pan:0.0f gain:.5f];
        body->SetActive(false);
        characterState = kStateActionButtonPressed;
        numActionItems--;
    }
    
}
-(void)setDelegate:(id<GameplayLayerDelegate>)del {
    delegate = del;
    [delegate registerGameObjectTarget:self action:kActionControlButton selector:@selector(jetpackActionPressed)];
}


@end
 */
