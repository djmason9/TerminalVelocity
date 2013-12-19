//
//  Bird.mm
//  TerminalVelocity
//
//  Created by Aaron Jones on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Bird.h"
#import "Box2DHelpers.h"
#import "GameManager.h"

#define WAIT_TIME WAIT_TIME_BIRD

@implementation Bird
@synthesize flyingAnim;

-(void)dealloc {
    CCLOG(@"Bird::dealloc");
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
    
    self = [self initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bird00001.png"]];
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
       
        int num = 8;
        b2Vec2 verts[] = {
            b2Vec2(-22.0f / VECTOR_PTM_RATIO, 13.7f / VECTOR_PTM_RATIO),
            b2Vec2(-20.2f / VECTOR_PTM_RATIO, -17.0f / VECTOR_PTM_RATIO),
            b2Vec2(12.0f / VECTOR_PTM_RATIO, -21.2f / VECTOR_PTM_RATIO),
            b2Vec2(22.0f / VECTOR_PTM_RATIO, -7.7f / VECTOR_PTM_RATIO),
            b2Vec2(12.5f / VECTOR_PTM_RATIO, 8.2f / VECTOR_PTM_RATIO),
            b2Vec2(2.0f / VECTOR_PTM_RATIO, 16.5f / VECTOR_PTM_RATIO),
            b2Vec2(-10.7f / VECTOR_PTM_RATIO, 21.7f / VECTOR_PTM_RATIO),
            b2Vec2(-22.0f / VECTOR_PTM_RATIO, 14.0f / VECTOR_PTM_RATIO)
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
        lastRand = 0;
        lastSign = NO;
        waitTime = arc4random_uniform(WAIT_TIME)+1;
        characterState = kStateIdle;
        [self setGameObjectType:kSmallObject];
        [self setFlyingAnim:[self loadPlistForAnimationWithName:@"birdFlyingAnim" andClassName:@"GameObjects"]];
    }
    return self;
}

-(void)changeState:(CharacterStates)newState {
    [self setCharacterState:newState];
	
	switch (newState) {
        case kStateHitBroward: {
            [self stopAllActions];
            //play sound
            PLAYSOUNDEFFECT(BIRD_CRASH);
            body->SetActive(false);
            //[self animateCollision];
            
            CCParticleSystem *smoke = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"birdexplosion.plist"];
            [smoke setAutoRemoveOnFinish:YES];
            [smoke setPosition:self.position];
            [smoke setScale:1.0];
            
            float rot = arc4random_uniform(180);
            [smoke setRotation:rot];
            
            [self.parent.parent addChild:smoke];
            
            [GameManager sharedGameManager].score += 50;
            
            CCLabelBMFont *scoreLabel = [CCLabelBMFont labelWithString:@"+50" fntFile:@"menus.fnt"];
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
    static int i=0;
    
    randFlightTime = arc4random_uniform(2)+1;
    b2Vec2 vel;
    int rand = arc4random_uniform(2) +1;
    int speed = arc4random_uniform(3)+1;
    
    int direction= 0;
    
    if(i%2>0)
       direction = arc4random_uniform(2)?-1:1;
        
    if(direction<0)
        [self setFlipX:YES];
    else
        [self setFlipX:NO];
    
    vel.Set(direction *rand, 2.0f*speed);
    body->SetLinearVelocity(vel);
    
    i++;
}


-(void)resetObject {
    time = 0.0f;
    body->SetActive(false);
    
    waitTime = arc4random_uniform(WAIT_TIME)+1;
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
    b2Vec2 pos;
    pos.Set(randomNum/PTM_RATIO, -10/PTM_RATIO);
    body->SetTransform(pos, 0);
    self.position = ccp(randomNum, -40);
    self.visible = NO;
    
    body->SetLinearVelocity(b2Vec2_zero);
    
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
            [self changeState:kStateMoving];
        }
        
    } else if ([self isObjectOffScreen]) {
        [self resetObject];
        
    } else if (isBodyCollidingWithObjectType(body, kBroward)) {
        //Hit 500 birds
        GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper]; 
        GKAchievement* achievement = [gkHelper getAchievementByID:@"birdEye"];//birdEye
        float percent = achievement.percentComplete + .25; 
        [gkHelper reportAchievementWithID:achievement.identifier percentComplete:percent];        
        
        [self objectsAchievmentIsComplete:achievement.identifier achievementTitle:@"Birds Eye"];
        
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
