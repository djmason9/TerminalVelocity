//
//  Bird.mm
//  TerminalVelocity
//
//  Created by Aaron Jones on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Bees.h"
#import "Box2DHelpers.h"
#import "GameManager.h"

@implementation Bees
@synthesize flyingAnim;

-(void)dealloc {
    CCLOG(@"Bees::dealloc");
    [flyingAnim release];
    [super dealloc];
}


-(id)initRandomInWorld:(b2World *)world {
    CGSize size = [CCDirector sharedDirector].winSize;
    int randomNum = arc4random_uniform( (int)(size.width - self.boundingBox.size.width));
    if (randomNum <= self.boundingBox.size.width) {
        randomNum = self.boundingBox.size.width + 10;
    }
    
    return [self initWithWorld:world atLocation:ccp(randomNum, -40)]; 
}

-(id)initWithWorld:(b2World *)world atLocation:(CGPoint)location {
    
    self = [self initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bees00001.png"]];
    //[self setScale:.5];
    if (self) {
      
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
       
        int num = 7;
        b2Vec2 verts[] = {
            b2Vec2(-4.0f / VECTOR_PTM_RATIO, -2.0f / VECTOR_PTM_RATIO),
            b2Vec2(-84.0f / VECTOR_PTM_RATIO, -3.0f / VECTOR_PTM_RATIO),
            b2Vec2(-118.0f / VECTOR_PTM_RATIO, -45.0f / VECTOR_PTM_RATIO),
            b2Vec2(-86.0f / VECTOR_PTM_RATIO, -88.0f / VECTOR_PTM_RATIO),
            b2Vec2(-16.0f / VECTOR_PTM_RATIO, -96.0f / VECTOR_PTM_RATIO),
            b2Vec2(34.0f / VECTOR_PTM_RATIO, -56.0f / VECTOR_PTM_RATIO),
            b2Vec2(-5.0f / VECTOR_PTM_RATIO, -3.0f / VECTOR_PTM_RATIO)
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
        randFlight = 0.0f;
        arc4random_stir();
        waitTime = arc4random_uniform(WAIT_TIME_BEE) + 1;
        characterState = kStateIdle;
        [self setGameObjectType:kSmallObject];
        [self setFlyingAnim:[self loadPlistForAnimationWithName:@"beesFlyingAnim" andClassName:@"GameObjects"]];
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
            [self resetObject];
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

    //broward dies
}

-(void)resetObject {
    time = 0.0f;
    body->SetActive(false);
    //arc4random_stir();
    waitTime = arc4random_uniform(WAIT_TIME_BEE) + 1;
    //arc4random_stir();
    int randomNum = arc4random_uniform( (int)(screenSize.width - self.boundingBox.size.width));
    if (randomNum <= self.boundingBox.size.width) {
        randomNum = self.boundingBox.size.width + 10;
        //CCLOG(@"box=%f rand=%i", self.boundingBox.size.width, randomNum);
    }
    
    [self setCharacterState:kStateIdle];
    b2Vec2 pos;
    pos.Set(randomNum/PTM_RATIO, -10/PTM_RATIO);
    body->SetTransform(pos, 0);
    self.position = ccp(randomNum, -40);
    self.visible = NO;
    b2Vec2 vel;
    //int randomVel = arc4random() % 5;
    vel.Set(0, 0);
    
    body->SetLinearVelocity(vel);
    
    // -1 or 1
    //int sign = arc4random() % 2 ? 1 : -1;
    //int angVel = sign * (1 + (arc4random() % 10));
    //body->SetAngularVelocity(0);
    [super resetObject];
}

-(void)startObject {
    
    
   /* static int once = 0;
    
    if(once==0 && [GameManager sharedGameManager].difficultyLevel > kDifficultyHard)
    {
        
        once++;
        CGSize size = [CCDirector sharedDirector].winSize;
        CCLabelBMFont *avoidLbl = [CCLabelBMFont labelWithString:@"Avoid the Bees!!" fntFile:@"deathobject.fnt"];
        avoidLbl.position = ccp(size.width *.5, size.height *.5);
        [self.parent.parent addChild:avoidLbl];
        id fadeOut = [CCFadeOut actionWithDuration:2.0f];
        id remove = [CCCallBlockN actionWithBlock:^(CCNode *node){
            [node removeFromParentAndCleanup:YES];
            
            body->SetActive(true);
            self.visible = YES;
            //[self setScale:.5];
            b2Vec2 vel;
            
            vel.Set(0, 3.0f);
            
            body->SetLinearVelocity(vel);
            
            [self runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:flyingAnim]]];
            
        }];
        [avoidLbl runAction:[CCSequence actions:fadeOut, remove, nil]];
    }else
    {*/
        body->SetActive(true);
        self.visible = YES;
        //[self setScale:.5];
        b2Vec2 vel;
        
        vel.Set(0, 3.0f);
        
        body->SetLinearVelocity(vel);
        
        [self runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:flyingAnim]]];
   //}
    
    
    
}

-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects {
    if ([GameManager sharedGameManager].hasPlayerDied) {
        self.visible = NO;
        body->SetActive(false);
        return;
    }
    
    if (characterState == kStateIdle) {
        time += deltaTime;
        if (time >= waitTime) {
            static BOOL shown = NO;
            if(!shown && [GameManager sharedGameManager].difficultyLevel > kDifficultyHard) {
                shown = YES;
                CGSize size = [CCDirector sharedDirector].winSize;
                CCLabelBMFont *avoidLbl = [CCLabelBMFont labelWithString:@"Avoid the bees!!" fntFile:@"deathobject.fnt"];
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
    } else if(characterState == kStateMoving) {
        randFlight += deltaTime;
        if (randFlight >= 1.0) {
            
            randFlight = 0.0f;
            b2Vec2 vel;
            int rand = arc4random_uniform(2);
            int speed = arc4random_uniform(3)+1;
            
            vel.Set((arc4random_uniform(2)?-1*rand:1*rand), 2.0f*speed);
            //vel.Set(rand, 2.0f);
            body->SetLinearVelocity(vel);
        }
    }
}

@end
