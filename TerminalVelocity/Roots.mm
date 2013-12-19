//
//  Bird.mm
//  TerminalVelocity
//
//  Created by Aaron Jones on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Roots.h"
#import "Box2DHelpers.h"
#import "GameManager.h"

@implementation Roots



-(id)initRandomInWorld:(b2World *)world {
    
    int fixedNumber = 42;
    return [self initWithWorld:world atLocation:ccp(fixedNumber, -50)];
}

-(id)initWithWorld:(b2World *)world atLocation:(CGPoint)location {
    static int i=1;
    self = [self initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"roots_00004.png"]];
    if (self) {
        i++;
        if (i>2) 
            [self setFlipY:YES]; 
        
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
       // dynamicBox.SetAsBox(1,1);
        
        //row 1, col 1
        int num = 5;
        b2Vec2 verts[] = {
            b2Vec2(107.0f / VECTOR_PTM_RATIO, 60.5f / VECTOR_PTM_RATIO),
            b2Vec2(-119.0f / VECTOR_PTM_RATIO, 49.5f / VECTOR_PTM_RATIO),
            b2Vec2(-122.0f / VECTOR_PTM_RATIO, -43.5f / VECTOR_PTM_RATIO),
            b2Vec2(92.0f / VECTOR_PTM_RATIO, -47.5f / VECTOR_PTM_RATIO),
            b2Vec2(107.0f / VECTOR_PTM_RATIO, 58.5f / VECTOR_PTM_RATIO)
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
        arc4random_stir();
        waitTime = ((arc4random() % WAIT_TIME_ROOT) + 1);
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
    arc4random_stir();
    waitTime = ((arc4random() % WAIT_TIME_ROOT) + 1);
    arc4random_stir();
    int randomNum = arc4random() % (int)(screenSize.width - self.boundingBox.size.width);
    if (randomNum <= self.boundingBox.size.width) {
        randomNum = self.boundingBox.size.width + 10;
        //CCLOG(@"box=%f rand=%i", self.boundingBox.size.width, randomNum);
    }
    
    //NSLog(@"random number: %i",(arc4random() % 2)+1);
    int fixedNumber = 42;
    //flip it random yo!
    if(((arc4random() % 2)+1)==1)
    {
        fixedNumber = screenSize.width*.88;
        [self setFlipX:YES];
    }else
        [self setFlipX:NO];
    
    [self setCharacterState:kStateIdle];
    b2Vec2 pos;
    pos.Set(fixedNumber/PTM_RATIO, -50/PTM_RATIO);
    
    body->SetTransform(pos, 0);
    self.position = ccp(fixedNumber, -50);
    
    
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
    
    /*static int once = 0;
    
    if(once==0 && [GameManager sharedGameManager].difficultyLevel > kDifficultyHard)
    { once++;
        
        CGSize size = [CCDirector sharedDirector].winSize;
        CCLabelBMFont *avoidLbl = [CCLabelBMFont labelWithString:@"Avoid the Roots!!" fntFile:@"deathobject.fnt"];
        avoidLbl.position = ccp(size.width *.5, size.height *.5);
        [self.parent.parent addChild:avoidLbl];
        id fadeOut = [CCFadeOut actionWithDuration:2.0f];
        id remove = [CCCallBlockN actionWithBlock:^(CCNode *node){
            [node removeFromParentAndCleanup:YES];
            
            self.visible = YES;
            body->SetActive(true);
            //[self setFlipX:YES];
            b2Vec2 vel;
            vel.Set(0, 3.0f);
            body->SetLinearVelocity(vel);
            //[self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"root_00001.png"]];
        }];
        [avoidLbl runAction:[CCSequence actions:fadeOut, remove, nil]];
        
    }else
    {*/
        body->SetActive(true);
        self.visible = YES;
        b2Vec2 vel;
        vel.Set(0, 3.0f);
        
        body->SetLinearVelocity(vel);
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
                CCLabelBMFont *avoidLbl = [CCLabelBMFont labelWithString:@"Avoid the roots!!" fntFile:@"deathobject.fnt"];
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
