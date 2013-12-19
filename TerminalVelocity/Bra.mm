//
//  Bra.m
//  TerminalVelocity
//
//  Created by Aaron Jones on 12/6/11.
//  Copyright (c) 2011 Dark Energy Studios. All rights reserved.
//

#import "Bra.h"

#define WAIT_TIME 10

@implementation Bra
- (void)dealloc {
    [super dealloc];
}

-(id)initRandomInWorld:(b2World *)world {
    CGSize size = [CCDirector sharedDirector].winSize;
    int randomNum = arc4random() % (int)size.width;
    return [self initWithWorld:world atLocation:ccp(randomNum, -10)]; 
}

-(id)initWithWorld:(b2World *)world atLocation:(CGPoint)location {
    
    //08,09,10,12
    static int imageNum = 8;
    NSString *imageName = [NSString stringWithFormat:@"clothes%05d.png", imageNum];
    self = [self initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:imageName]];
    imageNum++;
    if (self) {
        [self setPosition:location];
        // Define the dynamic body.
        //Set up a 1m squared box in the physics world
        b2BodyDef bodyDef;
        bodyDef.type = b2_kinematicBody ;
        bodyDef.position.Set(location.x/PTM_RATIO, location.y/PTM_RATIO);
        bodyDef.userData = self;
        bodyDef.fixedRotation = true;
        body = world->CreateBody(&bodyDef);
        
        // Define another box shape for our dynamic body.
        b2PolygonShape dynamicBox;
        dynamicBox.SetAsBox(self.contentSize.width/2/PTM_RATIO, self.contentSize.height/2/PTM_RATIO);//These are mid points for our 1m box
        
        /*
        int num = 5;
        b2Vec2 verts[] = {
            b2Vec2(26.5f / VECTOR_PTM_RATIO, 15.6f / VECTOR_PTM_RATIO),
            b2Vec2(30.1f / VECTOR_PTM_RATIO, -30.4f / VECTOR_PTM_RATIO),
            b2Vec2(-26.5f / VECTOR_PTM_RATIO, -31.1f / VECTOR_PTM_RATIO),
            b2Vec2(-28.3f / VECTOR_PTM_RATIO, 14.5f / VECTOR_PTM_RATIO),
            b2Vec2(25.5f / VECTOR_PTM_RATIO, 15.9f / VECTOR_PTM_RATIO)
        };
        

        
        dynamicBox.Set(verts, num);
         */
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

- (id)init
{
    self = [super init];
    if (self) {
        arc4random_stir();
        waitTime = ((arc4random() % WAIT_TIME) + 1);
        characterState = kStateIdle;
        self.visible = NO;
        [self setGameObjectType:kSmallObject];
    }
    
    return self;
    
}


-(void)startFlyingAnim {
    // -1 or 1
    int sign = arc4random() % 2 ? 1 : -1;
    int angVel = sign * (1 + (arc4random() % 10));
    body->SetAngularVelocity(angVel);
    //[self runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:flyingAnim]]];
}

-(void)animateCollision{
    
    //play sound
    PLAYSOUNDEFFECT(SPLAT);
    
    id rotate = [CCRotateBy actionWithDuration:1.0f angle:360];
    [self runAction:rotate];
    
    id move = [CCMoveTo actionWithDuration:1.0f position:ccp(-10,-10)];
    id remove = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [self resetObject];
    }];
    [self runAction:[CCSequence actions:move, remove, nil]];
    
}

-(void)setRandomPath {
    randFlightTime = arc4random_uniform(2)+1;
    b2Vec2 vel;
    int rand = arc4random_uniform(2) +1;
    int speed = arc4random_uniform(3)+1;
    int direction= arc4random_uniform(2)?-1:1;
    
    if(direction<0)
        [self setFlipX:YES];
    else
        [self setFlipX:NO];
    
    vel.Set(direction *rand, 2.0f*speed);
    body->SetLinearVelocity(vel);
}

-(void)resetObject {
    time = 0.0f;
    characterState = kStateIdle;
    body->SetActive(false);
    waitTime = arc4random_uniform(WAIT_TIME) + 3;
    
    static float bbox = screenSize.width - self.boundingBox.size.width;
    
    int randomNum = arc4random_uniform((int)bbox);
    if (randomNum <= self.boundingBox.size.width) {
        randomNum = self.boundingBox.size.width + 10;
    }
    b2Vec2 pos;
    pos.Set(randomNum/PTM_RATIO, -10/PTM_RATIO);
    //pos.Set(5/PTM_RATIO, 0);
    body->SetTransform(pos, 0);
    self.position = ccp(randomNum, -40);
    self.visible = NO;

    body->SetLinearVelocity(b2Vec2_zero);
    [self stopAllActions];
    [super resetObject];
    
}


-(void)startObject {
    self.visible = YES;
    body->SetActive(true);
    [self setRandomPath];
    [self startFlyingAnim];
}

-(void)changeState:(CharacterStates)newState {
    [self setCharacterState:newState];
	
	switch (newState) {
        case kStateHitBroward: {
            [self stopAllActions];
            body->SetActive(false);
            [self animateCollision];
            
            [GameManager sharedGameManager].score += 100;
            CCLabelBMFont *scoreLabel = [CCLabelBMFont labelWithString:@"+100" fntFile:@"menus.fnt"];
            scoreLabel.position = self.position;
            [self.parent.parent addChild:scoreLabel];
            
            id fadeOut = [CCFadeOut actionWithDuration:1.0f];
            id remove = [CCCallBlockN actionWithBlock:^(CCNode *node){
                [node removeFromParentAndCleanup:YES];
            }];
            [scoreLabel runAction:[CCSequence actions:fadeOut, remove, nil]];
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


-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects {
    
    if ([GameManager sharedGameManager].hasPlayerDied) {
        self.visible = NO;
        body->SetActive(false);
        return;
    } else if (characterState == kStateIdle) {
        time += deltaTime;
        //runTime = 0;
        if (time >= waitTime) {
            [self changeState:kStateMoving];
        }
        
    } else if ([self isObjectOffScreen]) {
        [self resetObject];
    } else if (isBodyCollidingWithObjectType(body, kBroward)) {
        //hit 20 trash items to full fill achievment
        //GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper]; 
        //GKAchievement* achievement = [gkHelper getAchievementByID:@"trashMan"];//trashMan
        //float percent = achievement.percentComplete + 5; 
        //[gkHelper reportAchievementWithID:achievement.identifier percentComplete:percent];
        
        //[self objectsAchievmentIsComplete:achievement.identifier achievementTitle:@"Trash Man"];
        
        [self changeState:kStateHitBroward]; 
    }else if(characterState == kStateMoving) {
        if (randFlight >= randFlightTime) {
            randFlight = 0.0f;
            [self setRandomPath];
        } else {
            randFlight += deltaTime;
        }
    }
    
}
@end
