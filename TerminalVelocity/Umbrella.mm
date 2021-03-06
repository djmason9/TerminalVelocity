//
//  AlienShip.mm
//  TerminalVelocity
//
//  Created by Aaron Jones on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Umbrella.h"
#import "Box2DHelpers.h"
#import "GameManager.h"


@implementation Umbrella
@synthesize flyingAnim,crashAnim;
- (void)dealloc {
    [flyingAnim release];
    [super dealloc];
}

-(id)initRandomInWorld:(b2World *)world {
    CGSize size = [CCDirector sharedDirector].winSize;
    int randomNum = arc4random_uniform((int)size.width);
    return [self initWithWorld:world atLocation:ccp(randomNum, -10)]; 
}

-(id)initWithWorld:(b2World *)world atLocation:(CGPoint)location {
    self = [self initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"umbrella00001.png"]];
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
        dynamicBox.SetAsBox((self.contentSize.width*0.5)/2/PTM_RATIO, (self.contentSize.height*0.5)/2/PTM_RATIO);//These are mid points for 
    
        int num = 5;
        b2Vec2 verts[] = {
            b2Vec2(49.5f / VECTOR_PTM_RATIO, 57.0f / VECTOR_PTM_RATIO),
            b2Vec2(-19.5f / VECTOR_PTM_RATIO, 68.0f / VECTOR_PTM_RATIO),
            b2Vec2(-69.5f / VECTOR_PTM_RATIO, 51.0f / VECTOR_PTM_RATIO),
            b2Vec2(-5.5f / VECTOR_PTM_RATIO, -48.0f / VECTOR_PTM_RATIO),
            b2Vec2(47.5f / VECTOR_PTM_RATIO, 57.0f / VECTOR_PTM_RATIO)
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
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        randFlight = 0.0f;
        maxUmbrella=1;

        waitTime = arc4random_uniform(WAIT_TIME_UMBRELLA) + 3;
        characterState = kStateIdle;
        self.visible = NO;
        
        [self setGameObjectType:kLargeObject];
        [self setFlyingAnim:[self loadPlistForAnimationWithName:@"umbrellaFlyingAnim" andClassName:@"GameObjects"]];
        [self setCrashAnim:[self loadPlistForAnimationWithName:@"umbrellaCrashAnim" andClassName:@"GameObjects"]];

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
            body->SetActive(false);
            
            [self animateCollision];
            
            [GameManager sharedGameManager].score += 150;
            CCLabelBMFont *scoreLabel = [CCLabelBMFont labelWithString:@"+150" fntFile:@"menus.fnt"];
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

-(void)startFlyingAnim {
    // -1 or 1
    int sign = arc4random_uniform(2)? 1 : -1;
    int angVel = sign * (arc4random_uniform(10) +1);
    body->SetAngularVelocity(angVel);
    [self runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:flyingAnim]]];
}

-(void)updateRotation {
    float angle = CC_RADIANS_TO_DEGREES(body->GetAngle() * -1);
    if (angle < -45.0f || angle > 45.0f) {
        float angleVel = body->GetAngularVelocity();
        body->SetAngularVelocity(-1*angleVel);
    }
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

-(void)setRandomPath {
    randFlightTime = arc4random_uniform(2)+1;
    b2Vec2 vel;
    int rand = arc4random_uniform(2) +1;
    //int speed = arc4random_uniform(3)+1;
    int direction= arc4random_uniform(2)?-1:1;
    
    if(direction<0)
        [self setFlipX:YES];
    else
        [self setFlipX:NO];
    
    vel.Set(direction *rand, 2.0f);
    body->SetLinearVelocity(vel);
}

-(void)resetObject {
    if(maxUmbrella <= MAX_SECONDARY_OBJECT)
    {
        time = 0.0f;
        characterState = kStateIdle;
        body->SetActive(false);
        
        arc4random_stir();
        waitTime = ((arc4random() % WAIT_TIME_UMBRELLA) + 3);
        
        int randomNum = arc4random_uniform((int)(screenSize.width - self.boundingBox.size.width));
        if (randomNum <= self.boundingBox.size.width) {
            randomNum = self.boundingBox.size.width + 10;
        }

        b2Vec2 pos;
        pos.Set(randomNum/PTM_RATIO, -10/PTM_RATIO);
        body->SetTransform(pos, 0);
        self.position = ccp(randomNum, -40);
        self.visible = NO;
        
        body->SetLinearVelocity(b2Vec2_zero);
        [self stopAllActions];
        maxUmbrella++;
    }else {
        removeObject = YES;
    }
    [super resetObject];
    
}

-(void)startObject {
    self.visible = YES;
    body->SetActive(true);
    [self setRandomPath];
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
        GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper]; 
        GKAchievement* achievement = [gkHelper getAchievementByID:@"singingInTheRain"];
        float percent = achievement.percentComplete + 5; 
        [gkHelper reportAchievementWithID:achievement.identifier percentComplete:percent];        
        
         [self objectsAchievmentIsComplete:achievement.identifier achievementTitle:@"Singing In The Rain"];
        
        [self changeState:kStateHitBroward]; 
    } else if(characterState ==kStateMoving) {
        if (randFlight >= randFlightTime) {
            randFlight = 0.0f;
            [self setRandomPath];
        } else {
            randFlight += deltaTime;
        }
    }
}
@end
