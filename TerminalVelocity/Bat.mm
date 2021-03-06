//
//  Bird.mm
//  TerminalVelocity
//
//  Created by Aaron Jones on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Bat.h"
#import "Box2DHelpers.h"
#import "GameManager.h"

@implementation Bat
@synthesize flyingAnim;

-(void)dealloc {
    CCLOG(@"Bat::dealloc");
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
    self = [self initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bat00001.png"]];
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

        int num = 7;
        b2Vec2 verts[] = {
            b2Vec2(14.0f / VECTOR_PTM_RATIO, 26.0f / VECTOR_PTM_RATIO),
            b2Vec2(-22.0f / VECTOR_PTM_RATIO, 27.0f / VECTOR_PTM_RATIO),
            b2Vec2(-38.0f / VECTOR_PTM_RATIO, -1.0f / VECTOR_PTM_RATIO),
            b2Vec2(-23.0f / VECTOR_PTM_RATIO, -22.0f / VECTOR_PTM_RATIO),
            b2Vec2(-5.0f / VECTOR_PTM_RATIO, -24.0f / VECTOR_PTM_RATIO),
            b2Vec2(19.0f / VECTOR_PTM_RATIO, -6.0f / VECTOR_PTM_RATIO),
            b2Vec2(13.0f / VECTOR_PTM_RATIO, 28.0f / VECTOR_PTM_RATIO)
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
        //arc4random_stir();
        waitTime = arc4random_uniform(WAIT_TIME_BAT) + 1;
        characterState = kStateIdle;
        [self setGameObjectType:kSmallObject];
        [self setFlyingAnim:[self loadPlistForAnimationWithName:@"batFlyingAnim" andClassName:@"GameObjects"]];
    }
    return self;
}

-(void)changeState:(CharacterStates)newState {
    [self setCharacterState:newState];
	
	switch (newState) {
        case kStateHitBroward: {
            [self stopAllActions];
            //play sound
            PLAYSOUNDEFFECT(BAT);
            body->SetActive(false);
            //[self animateCollision];
            
            CCParticleSystem *smoke = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"blood.plist"];
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
    int rand = arc4random_uniform(2);
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
    waitTime = arc4random_uniform(WAIT_TIME_BAT) + 1;
    int randomNum = arc4random_uniform( (int)(screenSize.width - self.boundingBox.size.width));
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
            //NSLog(@"waitTime=%f damping=%f", waitTime, body->GetLinearDamping());
            [self changeState:kStateMoving];
        }
        
    } else if ([self isObjectOffScreen]) {
        [self resetObject];
        
    } else if (isBodyCollidingWithObjectType(body, kBroward)) {
        //Hit 500 bats
        GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper]; 
        GKAchievement* achievement = [gkHelper getAchievementByID:@"batMan"];//batMan
        float percent = achievement.percentComplete + .25; 
        [gkHelper reportAchievementWithID:achievement.identifier percentComplete:percent];        
        
        [self objectsAchievmentIsComplete:achievement.identifier achievementTitle:@"Bat Man"];
        
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
