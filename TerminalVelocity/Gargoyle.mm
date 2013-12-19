//
//  Bird.mm
//  TerminalVelocity
//
//  Created by Aaron Jones on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Gargoyle.h"
#import "Box2DHelpers.h"
#import "GameManager.h"

@implementation Gargoyle


-(void)dealloc {
    [super dealloc];
}


-(id)initRandomInWorld:(b2World *)world {
    
    int fixedNumber = 10;
    return [self initWithWorld:world atLocation:ccp(fixedNumber, -50)];
}

-(id)initWithWorld:(b2World *)world atLocation:(CGPoint)location {
    
    self = [self initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"gargoyle00001.png"]];
    if (self) {
        gameManager = [GameManager sharedGameManager];
        [self setPosition:location];
        // Define the dynamic body.
        //Set up a 1m squared box in the physics world
        b2BodyDef bodyDef;
        bodyDef.type = b2_kinematicBody;
        //CGRect r = broward.textureRect;
        bodyDef.position.Set(location.x/PTM_RATIO, location.y/PTM_RATIO);
        bodyDef.userData = self;
        bodyDef.fixedRotation = true;
        body = world->CreateBody(&bodyDef);
        
        // Define another box shape for our dynamic body.
        b2PolygonShape dynamicBox;
       
        int num = 6;
        b2Vec2 verts[] = {
            b2Vec2(42.5f / VECTOR_PTM_RATIO, 74.0f / VECTOR_PTM_RATIO),
            b2Vec2(-8.5f / VECTOR_PTM_RATIO, 70.0f / VECTOR_PTM_RATIO),
            b2Vec2(-60.5f / VECTOR_PTM_RATIO, -27.0f / VECTOR_PTM_RATIO),
            b2Vec2(-34.5f / VECTOR_PTM_RATIO, -93.0f / VECTOR_PTM_RATIO),
            b2Vec2(26.5f / VECTOR_PTM_RATIO, -36.0f / VECTOR_PTM_RATIO),
            b2Vec2(43.5f / VECTOR_PTM_RATIO, 69.0f / VECTOR_PTM_RATIO)
        };

        dynamicBox.Set(verts, num);
        // Define the dynamic body fixture.
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &dynamicBox;	
        fixtureDef.density = 0.0f;
        fixtureDef.friction = 0.0f;
        fixtureDef.restitution = 0.0f;
        fixtureDef.isSensor = true;
        body->CreateFixture(&fixtureDef);
        body->SetActive(false);
        
        
    }
    return self;
}

-(id)init {
    self = [super init];
    if (self) {
        waitTime = arc4random_uniform(WAIT_TIME_GARGOYLE) + 1;
        characterState = kStateIdle;
        [self setGameObjectType:kSmallObject];
    }
    return self;
}

-(void)changeState:(CharacterStates)newState {
    [self setCharacterState:newState];
	
	switch (newState) {
        case kStateHitBroward: {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            [self stopAllActions];
            //play sound
           PLAYSOUNDEFFECT(FART);
            body->SetActive(false);
            [GameManager sharedGameManager].score -= 500;
            
            CCLabelBMFont *scoreLabel = [CCLabelBMFont labelWithString:@"-500" fntFile:@"deathobject.fnt"];
            scoreLabel.position = self.position;
            [self.parent.parent addChild:scoreLabel];
            id fadeOut = [CCFadeOut actionWithDuration:1.0f];
            id remove = [CCCallBlockN actionWithBlock:^(CCNode *node){
                [node removeFromParentAndCleanup:YES];
            }];
            [scoreLabel runAction:[CCSequence actions:fadeOut, remove, nil]];
            [self animateCollision];
            
            break;
        }
        case kStateMoving: {
            [self startObject];
            break;
        }
        default:
            break;
    }
}

-(void)animateCollision{
    
    id rotate = [CCRotateBy actionWithDuration:1.0f angle:360];
    [self runAction:rotate];
    
    id move = [CCMoveTo actionWithDuration:1.0f position:ccp(-10,-10)];
    id remove = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [self resetObject];
    }];
    [self runAction:[CCSequence actions:move, remove, nil]];
}

-(void)resetObject {
    
    time = 0.0f;
    body->SetActive(false);
    waitTime = arc4random_uniform(WAIT_TIME_GARGOYLE)+1;
    // old value 40
    int fixedNumber = 10;
    //flip it random yo!
    if(arc4random_uniform(2)?YES:NO)
    {
        fixedNumber = screenSize.width-10;
        [self setFlipX:YES];
    }else
        [self setFlipX:NO];
    
    [self setCharacterState:kStateIdle];
    b2Vec2 pos;
    pos.Set(fixedNumber/PTM_RATIO, -50/PTM_RATIO);
    
    body->SetTransform(pos, 0);
    self.position = ccp(fixedNumber, -50);
    self.visible = NO;
    
    body->SetLinearVelocity(b2Vec2_zero);
    [super resetObject];
}

-(void)startObject {
    body->SetActive(true);
    self.visible = YES;
    b2Vec2 vel;
    vel.Set(0, 3.0f);
    
    body->SetLinearVelocity(vel);
}

-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects {
    if (gameManager.hasPlayerDied) {
        self.visible = NO;
        body->SetActive(false);
    } else if (characterState == kStateIdle) {
        time += deltaTime;
        if (time >= waitTime) {
            static BOOL shown = NO;
            if(!shown && [GameManager sharedGameManager].difficultyLevel > kDifficultyHard) {
                shown = YES;
                CGSize size = [CCDirector sharedDirector].winSize;
               CCLabelBMFont *avoidLbl = [CCLabelBMFont labelWithString:@"Avoid the gargoyles!!" fntFile:@"deathobject.fnt"];
                avoidLbl.position = ccp(size.width *.5, size.height *.5);
                [self.parent.parent addChild:avoidLbl];
                id fadeOut = [CCFadeOut actionWithDuration:2.0f];
                id remove = [CCCallBlockN actionWithBlock:^(CCNode *node){
                    [node removeFromParentAndCleanup:YES];
                }];
                [avoidLbl runAction:[CCSequence actions:fadeOut, remove, nil]];
            }
            [self changeState:kStateMoving];
        }
        
    } else if ([self isObjectOffScreen]) {
        [self resetObject];
        
    } else if (isBodyCollidingWithObjectType(body, kBroward)) {
        
        [self changeState:kStateHitBroward]; 
    } 
}

@end
