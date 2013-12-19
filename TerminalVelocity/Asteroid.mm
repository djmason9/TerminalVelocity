//
//  Asteroid.mm
//  TerminalVelocity
//
//  Created by Aaron Jones on 7/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#define WAIT_TIME 2

#import "Asteroid.h"
#import "Box2DHelpers.h"
#import "Constants.h"
#import "GameManager.h"

@implementation Asteroid



-(id)initRandomInWorld:(b2World *)world {
    CGSize size = [CCDirector sharedDirector].winSize;
    int randomNum = arc4random_uniform( (int)(size.width - self.boundingBox.size.width));
    if (randomNum <= self.boundingBox.size.width) {
        randomNum = self.boundingBox.size.width + 10;
    }
    
    return [self initWithWorld:world atLocation:ccp(randomNum, -40)]; 
}

-(id)initWithWorld:(b2World *)world atLocation:(CGPoint)location {
    int randRock = arc4random_uniform(2)?1 :2;
    NSString *rock = [[NSString alloc] initWithFormat:@"rock0000%i.png",randRock];
    
    self = [self initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:rock]];
    [rock release];
    
    //self = [self initWithFile:@"test.png"];
    if (self) {
        [self setPosition:location];
        //[self setAnchorPoint:ccp(0.5f, 0.5f)];
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
        //CGSize box = self.contentSizeInPixels;
        dynamicBox.SetAsBox(self.boundingBox.size.width/2/PTM_RATIO, self.boundingBox.size.height/2/PTM_RATIO);//These are mid points for our 1m box
        //dynamicBox.SetAsBox(1,1);
       
        // Define the dynamic body fixture.
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &dynamicBox;	
        fixtureDef.density = 0.0f;
        fixtureDef.friction = 0.0f;
        fixtureDef.restitution = 0.0f;
        fixtureDef.isSensor = true;
        body->CreateFixture(&fixtureDef);
        b2Vec2 vel;
        //int randomVel = arc4random() % 5;
        //vel.Set(0, 2.0f + randomVel);
        vel.Set(0, 0);
        body->SetLinearVelocity(vel);
        body->SetActive(false);
        // -1 or 1
        //int sign = arc4random() % 2 ? 1 : -1;
        //int angVel = sign * (1 + (arc4random() % 10));
        //body->SetAngularVelocity(angVel);
        //body->ApplyTorque(15);
        //body->SetTransform(body->GetPosition(), 20);
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        lastRand = 0;
        lastSign = NO;
        waitTime = arc4random_uniform(WAIT_TIME) + 1;
        characterState = kStateIdle;
        [self setGameObjectType:kSmallObject];
    }
    
    return self;
}

-(void)changeState:(CharacterStates)newState {
    [self setCharacterState:newState];
	
	switch (newState) {
        case kStateHitBroward: {
            [self stopAllActions];
            //play sound
            PLAYSOUNDEFFECT(ASTROID_CRASH);
            
            CCParticleSystem *smoke = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"asteroid-explode.plist"];
            [smoke setAutoRemoveOnFinish:YES];
            [smoke setPosition:self.position];
            [smoke setScale:1.0];
            
            float rot = arc4random_uniform(180);
            [smoke setRotation:rot];
            
            [self.parent.parent addChild:smoke];
            [GameManager sharedGameManager].score += 50;
            
            CCLabelBMFont *scoreLabel = [CCLabelBMFont labelWithString:@"+50" fntFile:@"menus.fnt"];
            [smoke addChild:scoreLabel];
            [scoreLabel setRotation:(-1 * rot)];
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

-(void)resetObject {
    isActive = false;
    time = 0.0f;
    body->SetActive(false);
    
     waitTime = arc4random_uniform(WAIT_TIME) + 1;
    
    int randomNum = arc4random_uniform(5) + 1;
    if (randomNum == lastRand) {
        lastSign ? randomNum +=2: randomNum -=2;
        lastSign = !lastSign;
    }
    lastRand = randomNum;
    randomNum = (randomNum*(screenSize.width/4)) - 38;
    
    
    if (randomNum <= self.boundingBox.size.width) {
        randomNum = self.boundingBox.size.width + 10;
    }
    
    [self setCharacterState:kStateIdle];
    static b2Vec2 pos;
    pos.Set(randomNum/PTM_RATIO, -10/PTM_RATIO);
    body->SetTransform(pos, 0);
    self.position = ccp(randomNum, -40);
    self.visible = NO;
    
    body->SetLinearVelocity(b2Vec2_zero);
    
    body->SetAngularVelocity(0);
    [super resetObject];
}

-(void)startObject {
    isActive = true;
    body->SetActive(true);
    self.visible = YES;
    static b2Vec2 vel;
    int randomVel = arc4random_uniform(5);
    vel.Set(0, 2.0f + randomVel);
    
    body->SetLinearVelocity(vel);
    
    int sign = arc4random_uniform(2)?1:-1;
    int angVel = sign * (1 + (arc4random_uniform(10)));
    body->SetAngularVelocity(angVel);
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
        GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper]; 
        GKAchievement* achievement = [gkHelper getAchievementByID:@"deepImpact"];
        float percent = achievement.percentComplete + .25; 
        [gkHelper reportAchievementWithID:achievement.identifier percentComplete:percent];
        
         [self objectsAchievmentIsComplete:achievement.identifier achievementTitle:@"Deep Impact"];
        
        [self changeState:kStateHitBroward]; 
    }
}

@end
