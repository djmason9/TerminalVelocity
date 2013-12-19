//
//  BlackHole.m
//  TerminalVelocity
//
//  Created by Darren Mason on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BlackHole.h"
#import "Box2DHelpers.h"


@implementation BlackHole

@synthesize dyingAnim;
- (void)dealloc {
    [dyingAnim release];
    [super dealloc];
}

-(id)initWithWorld:(b2World *)world atLocation:(CGPoint)location {
    self = [self initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"black_hole00001.png"]];
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
        CGSize box = self.contentSizeInPixels;
        dynamicBox.SetAsBox(self.boundingBox.size.width/2/PTM_RATIO, self.boundingBox.size.height/2/PTM_RATIO);//These are mid points for our 1m box
        //dynamicBox.SetAsBox(1,1);
        int num = 7;
        b2Vec2 verts[] = {
            b2Vec2(35.5f / VECTOR_PTM_RATIO, 4.0f / VECTOR_PTM_RATIO),
            b2Vec2(-42.5f / VECTOR_PTM_RATIO, -4.0f / VECTOR_PTM_RATIO),
            b2Vec2(-54.5f / VECTOR_PTM_RATIO, -45.0f / VECTOR_PTM_RATIO),
            b2Vec2(-5.5f / VECTOR_PTM_RATIO, -71.0f / VECTOR_PTM_RATIO),
            b2Vec2(71.5f / VECTOR_PTM_RATIO, -63.0f / VECTOR_PTM_RATIO),
            b2Vec2(78.5f / VECTOR_PTM_RATIO, -22.0f / VECTOR_PTM_RATIO),
            b2Vec2(33.5f / VECTOR_PTM_RATIO, 4.0f / VECTOR_PTM_RATIO)
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
        b2Vec2 vel;
        vel.Set(0, 2.0f);
        
        body->SetLinearVelocity(vel);
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setGameObjectType:kKillObject];
        // Initialization code here.
        [self setDyingAnim:[self loadPlistForAnimationWithName:@"blackHoleAnim" andClassName:@"GameObjects"]];

    }
    
    return self;
}

-(void)changeState:(CharacterStates)newState {
    [self setCharacterState:newState];
	
	switch (newState) {
        case kStateHitBroward: {
            //[self stopAllActions];
            b2Vec2 vel;
            //int xVel = arc4random() % 5;
            vel.Set(0, 0);
            //[backgroundLayer updateScroll:deltaTime acceleration:acceleration velocity:(0.7f*velocity)];
            body->SetLinearVelocity(vel);
            [self animateCollision];
            break;
        }
            
        default:
            break;
    }
}

-(void)animateCollision{
    
    id animateAction = [CCAnimate actionWithAnimation:dyingAnim restoreOriginalFrame:YES];
    
    [self runAction:animateAction];
    
}

-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects {
    if (isBodyCollidingWithObjectType(body, kBroward)) {
        [self changeState:kStateHitBroward]; 
        
    } else {
        //[self changeState:kStateFalling];
    }
}

@end
