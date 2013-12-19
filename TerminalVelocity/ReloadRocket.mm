//
//  Bird.mm
//  TerminalVelocity
//
//  Created by Aaron Jones on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ReloadRocket.h"
#import "Box2DHelpers.h"
#import "GameManager.h"

#define WAIT_TIME WAIT_TIME_RELOAD_ROCKET

@implementation ReloadRocket
@synthesize flyingAnim;

-(void)dealloc {
    CCLOG(@"ReloadRocket:dealloc");
    [flyingAnim release];
    [super dealloc];
}


-(id)initRandomInWorld:(b2World *)world {
    CGSize size = [CCDirector sharedDirector].winSize;
    int randomNum = arc4random_uniform((int)(size.width - self.boundingBox.size.width));
    if (randomNum <= self.boundingBox.size.width) {
        randomNum = self.boundingBox.size.width + 10;
    }
    
    return [self initWithWorld:world atLocation:ccp(randomNum, -40)]; 
}

-(id)initWithWorld:(b2World *)world atLocation:(CGPoint)location {
    
    self = [self initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rocket_reload00001.png"]];
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
//        dynamicBox.SetAsBox(1,1);
  
        //row 1, col 1
        int num = 5;
        b2Vec2 verts[] = {
            b2Vec2(-5.0f / VECTOR_PTM_RATIO, 39.0f / VECTOR_PTM_RATIO),
            b2Vec2(-43.0f / VECTOR_PTM_RATIO, 8.0f / VECTOR_PTM_RATIO),
            b2Vec2(2.0f / VECTOR_PTM_RATIO, -42.0f / VECTOR_PTM_RATIO),
            b2Vec2(45.0f / VECTOR_PTM_RATIO, 0.0f / VECTOR_PTM_RATIO),
            b2Vec2(-4.0f / VECTOR_PTM_RATIO, 40.0f / VECTOR_PTM_RATIO)
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
        waitTime = arc4random_uniform(WAIT_TIME) + 1;
        characterState = kStateIdle;
        [self setGameObjectType:kSmallObject];
        [self setFlyingAnim:[self loadPlistForAnimationWithName:@"reloadRocketFlyingAnim" andClassName:@"GameObjects"]];
    }
    return self;
}

-(void)changeState:(CharacterStates)newState {
    [self setCharacterState:newState];
	
	switch (newState) {
        case kStateHitBroward: {
            [self stopAllActions];
            //play sound
            PLAYSOUNDEFFECT(RELOAD);
            
            [delegate resetActionItems];
            
            body->SetActive(false);
            //[self animateCollision];
            
            [GameManager sharedGameManager].score += 25;
            
            CCLabelBMFont *scoreLabel = [CCLabelBMFont labelWithString:@"+25" fntFile:@"menus.fnt"];
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

-(void)setDelegate:(id<GameplayLayerDelegate>)del{
    delegate = del;
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
    //randFlightTime = arc4random_uniform(2)+1;
    b2Vec2 vel;
    //int rand = arc4random_uniform(2);
    //int speed = arc4random_uniform(3)+1;
    //int direction= arc4random_uniform(2)?-1:1;
    
    //if(direction<0)
    //    [self setFlipX:YES];
   // else
    //    [self setFlipX:NO];
    
    vel.Set(0, 2.0f);
    body->SetLinearVelocity(vel);
}

-(void)resetObject {

        time = 0.0f;
        body->SetActive(false);
        
        waitTime = arc4random_uniform(WAIT_TIME) + 1;
        
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
    
    if ([delegate getActionCount] == 0) {
        
    }
    
    if (characterState == kStateIdle && [delegate getActionCount] == 0) {
        if (characterState == kStateIdle) {
            time += deltaTime;
            if (time >= waitTime) {
                [self changeState:kStateMoving];
            }
        }
        
    } else if ([self isObjectOffScreen]) {
        [self resetObject];
        
    } else if (isBodyCollidingWithObjectType(body, kBroward)) {
       
        [self changeState:kStateHitBroward]; 
    } 
}

@end
