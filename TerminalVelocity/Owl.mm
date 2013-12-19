//
//  Owl.m
//  TerminalVelocity
//
//  Created by Darren Mason on 9/2/11.
//  Copyright (c) 2011 Dark Energy Studios. All rights reserved.
//

#import "Owl.h"

#import "Box2DHelpers.h"
#import "GameManager.h"

@implementation Owl

@synthesize flyingAnim;

-(void)dealloc {
    CCLOG(@"Owl::dealloc");
    [flyingAnim release];
    [super dealloc];
}


-(id)initRandomInWorld:(b2World *)world {
    CGSize size = [CCDirector sharedDirector].winSize;
    int randomNum = arc4random() % (int)(size.width - self.boundingBox.size.width);
    if (randomNum <= self.boundingBox.size.width) {
        randomNum = self.boundingBox.size.width + 10;
    }
    
    return [self initWithWorld:world atLocation:ccp(randomNum, -40)]; 
}

-(id)initWithWorld:(b2World *)world atLocation:(CGPoint)location {
    self = [self initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"owl00001.png"]];
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
        //dynamicBox.SetAsBox(self.contentSize.width/2/PTM_RATIO, self.contentSize.height/2/PTM_RATIO);//These are mid points for our 1m box
        //dynamicBox.SetAsBox(0.5,0.5);
        
        int num = 6;
        b2Vec2 verts[] = {
            b2Vec2(39.0f / VECTOR_PTM_RATIO, 27.0f / VECTOR_PTM_RATIO),
            b2Vec2(9.0f / VECTOR_PTM_RATIO, 37.0f / VECTOR_PTM_RATIO),
            b2Vec2(-24.0f / VECTOR_PTM_RATIO, 23.0f / VECTOR_PTM_RATIO),
            b2Vec2(-9.0f / VECTOR_PTM_RATIO, -17.0f / VECTOR_PTM_RATIO),
            b2Vec2(42.0f / VECTOR_PTM_RATIO, -15.0f / VECTOR_PTM_RATIO),
            b2Vec2(40.0f / VECTOR_PTM_RATIO, 24.0f / VECTOR_PTM_RATIO)
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
        maxOwls=1;
        waitTime = ((arc4random() % WAIT_TIME_OWL) + 1);
        characterState = kStateIdle;
        [self setGameObjectType:kSmallObject];
        [self setFlyingAnim:[self loadPlistForAnimationWithName:@"owlFlyingAnim" andClassName:@"GameObjects"]];
    }
    return self;
}

-(void)changeState:(CharacterStates)newState {
    [self setCharacterState:newState];
	
	switch (newState) {
        case kStateHitBroward: {
            [self stopAllActions];
            //play sound
            PLAYSOUNDEFFECT(BIRD);
            body->SetActive(false);
            //[self animateCollision];
            
            CCParticleSystem *smoke = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"birdexplosion2.plist"];
            [smoke setAutoRemoveOnFinish:YES];
            [smoke setPosition:self.position];
            [smoke setScale:1.0];
            
            float rot = arc4random() % 180;
            [smoke setRotation:rot];
            
            [self.parent.parent addChild:smoke];
            
            [GameManager sharedGameManager].score += 50;
            
            CCLabelBMFont *scoreLabel = [CCLabelBMFont labelWithString:@"+100" fntFile:@"menus.fnt"];
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
    int rand = arc4random_uniform(2);
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
    if(maxOwls <= MAX_SECONDARY_OBJECT)
    {
        time = 0.0f;
        body->SetActive(false);
        waitTime = arc4random_uniform(WAIT_TIME_OWL) + 1;
        int randomNum = arc4random_uniform((int)(screenSize.width - self.boundingBox.size.width));
        if (randomNum <= self.boundingBox.size.width) {
            randomNum = self.boundingBox.size.width + 10;
        }
        
        [self setCharacterState:kStateIdle];
        b2Vec2 pos;
        pos.Set(randomNum/PTM_RATIO, -10/PTM_RATIO);
        body->SetTransform(pos, 0);
        self.position = ccp(randomNum, -40);
        self.visible = NO;
        
        body->SetLinearVelocity(b2Vec2_zero);
        maxOwls++;
        
    
    }else {
        removeObject = YES;
    }
    [super resetObject];
}

-(void)startObject {
    body->SetActive(true);
    self.visible = YES;
    [self setRandomPath];
    
    [self runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:flyingAnim]]];
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
            //NSLog(@"waitTime=%f damping=%f", waitTime, body->GetLinearDamping());
            [self changeState:kStateMoving];
        }
        
    } else if ([self isObjectOffScreen]) {
        [self resetObject];
        
    } else if (isBodyCollidingWithObjectType(body, kBroward)) {
        //Hit 20 Owls
        GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper]; 
        GKAchievement* achievement = [gkHelper getAchievementByID:@"nightOwl"];//nightOwl
        float percent = achievement.percentComplete + 5; 
        [gkHelper reportAchievementWithID:achievement.identifier percentComplete:percent];        
        
        [self objectsAchievmentIsComplete:achievement.identifier achievementTitle:@"Night Owl"];
        
        [self changeState:kStateHitBroward]; 
    } else if(characterState == kStateMoving) {
        if (randFlight >= randFlightTime) {
            randFlight = 0.0f;
            [self setRandomPath];
        } else {
            randFlight += deltaTime;
        }
    }
}

@end