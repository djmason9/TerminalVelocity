//
//  AlienShip.mm
//  TerminalVelocity
//
//  Created by Aaron Jones on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Firework.h"
#import "Box2DHelpers.h"
#import "GameManager.h"


@implementation Firework
@synthesize flyingAnim,crashAnim;
- (void)dealloc {
    [flyingAnim release];
    [crashAnim release];
    [super dealloc];
}

-(id)initRandomInWorld:(b2World *)world {
    CGSize size = [CCDirector sharedDirector].winSize;
    int randomNum = arc4random_uniform( (int)(size.width - self.boundingBox.size.width));
    return [self initWithWorld:world atLocation:ccp(randomNum, -10)]; 
}

-(id)initWithWorld:(b2World *)world atLocation:(CGPoint)location {
    self = [self initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"firework00009.png"]];
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
        
        int num = 4;
        b2Vec2 verts[] = {
            b2Vec2(7.0f / VECTOR_PTM_RATIO, 74.0f / VECTOR_PTM_RATIO),
            b2Vec2(-8.0f / VECTOR_PTM_RATIO, 73.0f / VECTOR_PTM_RATIO),
            b2Vec2(-2.0f / VECTOR_PTM_RATIO, -104.0f / VECTOR_PTM_RATIO),
            b2Vec2(7.0f / VECTOR_PTM_RATIO, 72.0f / VECTOR_PTM_RATIO)
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
        arc4random_stir();
        waitTime = arc4random_uniform(WAIT_TIME_FIREWORK) + 1;
        characterState = kStateIdle;
        self.visible = NO;
        
        [self setGameObjectType:kLargeObject];
        [self setFlyingAnim:[self loadPlistForAnimationWithName:@"fireworkFlyingAnim" andClassName:@"GameObjects"]];
        [self setCrashAnim:[self loadPlistForAnimationWithName:@"fireworkCrashAnim" andClassName:@"GameObjects"]];
        //[self startFlyingAnim];
    }
    
    return self;
}

-(void)animateCollision{
    
    //play sound
    //PLAYSOUNDEFFECT(SATELLITE_CRASH);
    
    id animateAction = [CCAnimate actionWithAnimation:crashAnim restoreOriginalFrame:NO];
    
    id explode = [self runAction:animateAction];
    
    id remove = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [self resetObject];
    }];
    [self runAction:[CCSequence actions:explode, remove, nil]];
    
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
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            [self stopAllActions];
            PLAYSOUNDEFFECT(FART);
            body->SetActive(false);
            
            [self animateCollision];
            
            [GameManager sharedGameManager].score -= 500;
            
            CCLabelBMFont *scoreLabel = [CCLabelBMFont labelWithString:@"-500" fntFile:@"deathobject.fnt"];
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

    [self runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:flyingAnim]]];

}


-(void)resetObject {

        time = 0.0f;
        characterState = kStateIdle;
        body->SetActive(false);
        
        arc4random_stir();
        waitTime = arc4random_uniform(WAIT_TIME_FIREWORK) + 3;
        
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
    [super resetObject];
    
}

-(void)startObject {
    /*
    static int once = 0;
    
    if(once==0 && [GameManager sharedGameManager].difficultyLevel > kDifficultyHard)
    {
        once++;
        CGSize size = [CCDirector sharedDirector].winSize;
        CCLabelBMFont *avoidLbl = [CCLabelBMFont labelWithString:@"Avoid the Fireworks!!" fntFile:@"deathobject.fnt"];
        avoidLbl.position = ccp(size.width *.5, size.height *.5);
        [self.parent.parent addChild:avoidLbl];
        id fadeOut = [CCFadeOut actionWithDuration:2.0f];
        id remove = [CCCallBlockN actionWithBlock:^(CCNode *node){
            [node removeFromParentAndCleanup:YES];
            
            self.visible = YES;
            body->SetActive(true);
            b2Vec2 vel;
            vel.Set(0, 3.0f);
            body->SetLinearVelocity(vel);
            //play sound
            [self setScale:.8];
            PLAYSOUNDEFFECT(FIREWORK);
            [self startFlyingAnim];
            
        }];
        [avoidLbl runAction:[CCSequence actions:fadeOut, remove, nil]];
    }
    else
    {*/
        self.visible = YES;
        body->SetActive(true);
        b2Vec2 vel;
        vel.Set(0, 0);
        body->SetLinearVelocity(vel);
        //play sound
        [self setScale:.8];
        PLAYSOUNDEFFECT(FIREWORK);
        [self startFlyingAnim];
   // }
        

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
            static BOOL shown = NO;
            if(!shown && [GameManager sharedGameManager].difficultyLevel > kDifficultyHard) {
                shown = YES;
                CGSize size = [CCDirector sharedDirector].winSize;
                CCLabelBMFont *avoidLbl = [CCLabelBMFont labelWithString:@"Avoid the fireworks!!" fntFile:@"deathobject.fnt"];
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
        b2Vec2 vel = body->GetLinearVelocity();
        b2Vec2 newVel(0, vel.y + (5.0f*deltaTime));
        body->SetLinearVelocity(newVel);
    }
}
@end
