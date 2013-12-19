//
//  AlienShip.mm
//  TerminalVelocity
//
//  Created by Aaron Jones on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Satellite.h"
#import "Box2DHelpers.h"
#import "GameManager.h"


@implementation Satellite
@synthesize flyingAnim,crashAnim;
- (void)dealloc {
    [flyingAnim release];
    [crashAnim release];
    [super dealloc];
}

-(id)initRandomInWorld:(b2World *)world {
    CGSize size = [CCDirector sharedDirector].winSize;
    int randomNum = arc4random() % (int)size.width;
    return [self initWithWorld:world atLocation:ccp(randomNum, -10)]; 
}

-(id)initWithWorld:(b2World *)world atLocation:(CGPoint)location {
    self = [self initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"satellite00001.png"]];
    if (self) {         

        [self setPosition:location];
        // Define the dynamic body.
        //Set up a 1m squared box in the physics world
        b2BodyDef bodyDef;
        bodyDef.type = b2_kinematicBody ;
        //CGRect r = broward.textureRect;
        bodyDef.position.Set(location.x/PTM_RATIO, location.y/PTM_RATIO);
        bodyDef.userData = self;
        bodyDef.fixedRotation = true;
        body = world->CreateBody(&bodyDef);
        
        // Define another box shape for our dynamic body.
        b2PolygonShape dynamicBox;
       
        //row 1, col 1
        int num = 5;
        b2Vec2 verts[] = {
            b2Vec2(37.0f / VECTOR_PTM_RATIO, 51.0f / VECTOR_PTM_RATIO),
            b2Vec2(-95.0f / VECTOR_PTM_RATIO, 7.0f / VECTOR_PTM_RATIO),
            b2Vec2(-74.0f / VECTOR_PTM_RATIO, -23.0f / VECTOR_PTM_RATIO),
            b2Vec2(61.0f / VECTOR_PTM_RATIO, 23.0f / VECTOR_PTM_RATIO),
            b2Vec2(37.0f / VECTOR_PTM_RATIO, 54.0f / VECTOR_PTM_RATIO)
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
        //b2Vec2 vel;
        //vel.Set(0, 2.0f);
        //body->SetLinearVelocity(vel);
        body->SetActive(false);
        [self startFlyingAnim];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        randFlight = 0.0f;
        maxSatilite=1;
        arc4random_stir();
        waitTime = arc4random_uniform(WAIT_TIME_SAT) + 1;
        characterState = kStateIdle;
        self.visible = NO;
        
        [self setGameObjectType:kLargeObject];
        [self setFlyingAnim:[self loadPlistForAnimationWithName:@"satelliteAnim" andClassName:@"GameObjects"]];
        [self setCrashAnim:[self loadPlistForAnimationWithName:@"satelliteCrashAnim" andClassName:@"GameObjects"]];
        //[self startFlyingAnim];
    }
    
    return self;
}

-(void)checkAndClampSpritePosition {
    CGPoint currentSpritePosition = [self position];
    
    CGSize levelSize = [[GameManager sharedGameManager] getDimensionsOfCurrentScene];
    CGSize box = self.boundingBox.size;
    float xOffset = (box.width * self.scale)/2;
    //float xOffsetRight = levelSize.width - xOffset;
    
    if (currentSpritePosition.x < xOffset && body->IsActive()) {
        //[self setPosition:ccp(levelSize.width, currentSpritePosition.y)];
        b2Vec2 vel;
        b2Vec2 origPos = body->GetPosition();
        
        vel.Set(levelSize.width/PTM_RATIO, origPos.y);
        body->SetTransform(vel, 0);
    } else if (currentSpritePosition.x > (levelSize.width + xOffset) && body->IsActive()) {
        //[self setPosition:ccp((levelSize.width - xOffset), currentSpritePosition.y)];
        b2Vec2 vel;
        b2Vec2 origPos = body->GetPosition();
        
        vel.Set(0, origPos.y);
        body->SetTransform(vel, 0);
    }
}

-(BOOL)isObjectOffScreen {
    CGPoint p = self.position;
    
    if (p.y > screenSize.height) {
        return  YES;
    } else {
        return  NO;
    }
}


-(void)changeState:(CharacterStates)newState {
    [self setCharacterState:newState];
	
	switch (newState) {
        case kStateHitBroward: {
            [self stopAllActions];
            //b2Vec2 vel;
            //int xVel = arc4random() % 5;
            //vel.Set(-5, -5);
            //body->SetLinearVelocity(vel);
            //body->SetAngularVelocity(5);
            body->SetActive(false);
            
            [self animateCollision];
            
            [GameManager sharedGameManager].score += 150;
            CCLabelBMFont *scoreLabel = [CCLabelBMFont labelWithString:@"+150" fntFile:@"menus.fnt"];
            scoreLabel.position = self.position;
            [self.parent.parent addChild:scoreLabel];
            
            id fadeOut = [CCFadeOut actionWithDuration:1.0f];
            id remove = [CCCallBlockN actionWithBlock:^(CCNode *node){
                //CCLOG(@"REMOVE ALIEN SCORE LABEL");
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

-(void)startFlyingAnim {
    [self runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:flyingAnim]]];
}

-(void)animateCollision{
    
    //play sound
    PLAYSOUNDEFFECT(SATELLITE_CRASH);
    
    id animateAction = [CCAnimate actionWithAnimation:crashAnim restoreOriginalFrame:NO];
    
    [self runAction:animateAction];
    
    id rotate = [CCRotateBy actionWithDuration:1.0f angle:360];
    [self runAction:rotate];
    
    id move = [CCMoveTo actionWithDuration:1.0f position:ccp(-10,-10)];
    id remove = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [self resetObject];
    }];
    [self runAction:[CCSequence actions:move, remove, nil]];
    
}



-(void)resetObject {
    if(maxSatilite <= MAX_SECONDARY_OBJECT)
    {
        time = 0.0f;
        characterState = kStateIdle;
        body->SetActive(false);
        
        arc4random_stir();
        waitTime = arc4random_uniform(WAIT_TIME_SAT) + 3;
        
        int randomNum = arc4random() % (int)(screenSize.width - self.boundingBox.size.width);
        if (randomNum <= self.boundingBox.size.width) {
            randomNum = self.boundingBox.size.width + 10;
        }
        b2Vec2 pos;
        pos.Set(randomNum/PTM_RATIO, -10/PTM_RATIO);
        body->SetTransform(pos, 0);
        self.position = ccp(randomNum, -40);
        self.visible = NO;
        b2Vec2 vel;
        vel.Set(0, 0);
        body->SetLinearVelocity(vel);
        [self stopAllActions];
        maxSatilite++;
    }else {
        removeObject = YES;
    }
    [super resetObject];
    
}

-(void)startObject {
    //play sound
    PLAYSOUNDEFFECT(SATELLITE);
    self.visible = YES;
    body->SetActive(true);
    b2Vec2 vel;
    vel.Set(1, 2.0f);
    body->SetLinearVelocity(vel);
    [self startFlyingAnim];
}


-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects {
    if ([GameManager sharedGameManager].hasPlayerDied) {
        self.visible = NO;
        body->SetActive(false);
        return;
    }
    //[self checkAndClampSpritePosition];
    
    if (characterState == kStateIdle) {
        time += deltaTime;
        if (time >= waitTime) {
            [self changeState:kStateMoving];
        }
        
    } else if ([self isObjectOffScreen]) {
        [self resetObject];
    } else if (isBodyCollidingWithObjectType(body, kBroward)) {
        //hit 20 aliens to full fill achievment
        GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper]; 
        GKAchievement* achievement = [gkHelper getAchievementByID:@"satelliteCleaner"];
        float percent = achievement.percentComplete + 5; 
        [gkHelper reportAchievementWithID:achievement.identifier percentComplete:percent];        
        
        [self objectsAchievmentIsComplete:achievement.identifier achievementTitle:@"Satellite Cleaner"];
        
        [self changeState:kStateHitBroward]; 
    } else {
        randFlight += deltaTime;
        if (randFlight >= 2.0) {
            
            randFlight = 0.0f;
            b2Vec2 vel;
            vel.Set((arc4random_uniform(2)? -1:1), 2.0f);
            body->SetLinearVelocity(vel);
        }
    }
}
@end
