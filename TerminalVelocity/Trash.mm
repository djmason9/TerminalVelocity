//
//  AlienShip.mm
//  TerminalVelocity
//
//  Created by Aaron Jones on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Trash.h"
#import "Box2DHelpers.h"
#import "GameManager.h"

#define WAIT_TIME 2

@implementation Trash
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
    self = [self initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"trash00001.png"]];
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
        dynamicBox.SetAsBox(self.contentSize.width/2/PTM_RATIO, self.contentSize.height/2/PTM_RATIO);//These are mid points for our 1m box
      
       int num = 7;
       b2Vec2 verts[] = {
       b2Vec2(-33.0f / VECTOR_PTM_RATIO, 56.5f / VECTOR_PTM_RATIO),
       b2Vec2(-52.0f / VECTOR_PTM_RATIO, 42.5f / VECTOR_PTM_RATIO),
       b2Vec2(-47.0f / VECTOR_PTM_RATIO, 12.5f / VECTOR_PTM_RATIO),
       b2Vec2(-23.0f / VECTOR_PTM_RATIO, -38.5f / VECTOR_PTM_RATIO),
       b2Vec2(40.0f / VECTOR_PTM_RATIO, -7.5f / VECTOR_PTM_RATIO),
       b2Vec2(-10.0f / VECTOR_PTM_RATIO, 48.5f / VECTOR_PTM_RATIO),
       b2Vec2(-32.0f / VECTOR_PTM_RATIO, 55.5f / VECTOR_PTM_RATIO)
       };
    
        dynamicBox.Set(verts, num);
        //dynamicBox.SetAsBox(1,1); 
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

- (id)init
{
    self = [super init];
    if (self) {
        arc4random_stir();
        waitTime = arc4random_uniform(WAIT_TIME) + 1;
        characterState = kStateIdle;
        maxTrash=1;
        self.visible = NO;
        [self setGameObjectType:kSmallObject];
        [self setFlyingAnim:[self loadPlistForAnimationWithName:@"trashAnim" andClassName:@"GameObjects"]];
        [self setCrashAnim:[self loadPlistForAnimationWithName:@"trashCrashAnim" andClassName:@"GameObjects"]];
    }
    
    return self;

}


-(void)changeState:(CharacterStates)newState {
    [self setCharacterState:newState];
	
	switch (newState) {
        case kStateHitBroward: {
            [self stopAllActions];
            body->SetActive(false);
            [self animateCollision];
            
            [GameManager sharedGameManager].score += 100;
            CCLabelBMFont *scoreLabel = [CCLabelBMFont labelWithString:@"+100" fntFile:@"menus.fnt"];
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
    //randFlightTime = arc4random_uniform(2)+1;
    b2Vec2 vel;
    //int rand = arc4random_uniform(2);
    int speed = arc4random_uniform(3)+1;
    //int direction= arc4random_uniform(2)?-1:1;
    
    //if(direction < 0)
        //[self setFlipY:YES];
    //else
    //    [self setFlipX:NO];
    
    vel.Set(0, 2.0f + speed);
    body->SetLinearVelocity(vel);
}

-(void)resetObject {
    if(maxTrash <= MAX_SECONDARY_OBJECT)
    {
        time = 0.0f;
        characterState = kStateIdle;
        body->SetActive(false);
        waitTime = arc4random_uniform(WAIT_TIME) + 3;
        
        int randomNum = arc4random_uniform((int)(screenSize.width - self.boundingBox.size.width));
        if (randomNum <= self.boundingBox.size.width) {
            randomNum = self.boundingBox.size.width + 10;
        }
        b2Vec2 pos;
        pos.Set(randomNum/PTM_RATIO, -10/PTM_RATIO);
        //pos.Set(5/PTM_RATIO, 0);
        body->SetTransform(pos, 0);
        self.position = ccp(randomNum, -40);
        //self.position = ccp(5, 0);
        
        self.visible = NO;
        body->SetLinearVelocity(b2Vec2_zero);
        [self stopAllActions];
        maxTrash++;
    }else {
        removeObject = YES;
    }
    [super resetObject];
    
}


-(void)startObject {
    
    //play sound
    PLAYSOUNDEFFECT(SPUTNIK);
    
    self.visible = YES;
    body->SetActive(true);
    [self setRandomPath];
    [self startFlyingAnim];
}

//static float runTime = 0;

/*
static inline float bezierat( float a, float b, float c, ccTime t ) {
	return (-2*((1-t)*a - (1 - 2*t)*b - t*c));
}

static inline float bezierCubeAt( float p1, float q1, float q2, float p2, ccTime t ) {
	return (-3*(powf(1-t,2)*p1 - ((1-t)*(1-3*t)*q1) - t*(2-3*t)*q2 - powf(t, 2)*p2));
}
*/
-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects {
    
    if ([GameManager sharedGameManager].hasPlayerDied) {
        self.visible = NO;
        body->SetActive(false);
        return;
    }
    /*
    static CGPoint p0 = ccp(5,0);
    static CGPoint q1 = ccp(screenSize.width/5, screenSize.height/2);
    static CGPoint q2 = ccp(screenSize.width/2, screenSize.height/2);
    static CGPoint p2 = ccp(screenSize.width, screenSize.height/2);
    
    if (characterState == kStateMoving) {
        
        
        float x = bezierCubeAt(p0.x, q1.x, q2.x, p2.x, runTime);
        float y = bezierCubeAt(p0.y, q1.y, q2.y, p2.y, runTime);
        
        float s = sqrtf((x*x + y*y));
        x = x/ s;
        y = y/ s;
        //NSLog(@"x=%f, y=%f",x,y);
        b2Vec2 vel;
        vel.Set(4*x, 4*y);
        body->SetLinearVelocity(vel);
        runTime += deltaTime;
    }
    */
    if (characterState == kStateIdle) {
        time += deltaTime;
        //runTime = 0;
        if (time >= waitTime) {
            [self changeState:kStateMoving];
        }
        
    } else if ([self isObjectOffScreen]) {
        [self resetObject];
    } else if (isBodyCollidingWithObjectType(body, kBroward)) {
        //hit 20 trash items to full fill achievment
        GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper]; 
        GKAchievement* achievement = [gkHelper getAchievementByID:@"trashMan"];//trashMan
        float percent = achievement.percentComplete + 5; 
        [gkHelper reportAchievementWithID:achievement.identifier percentComplete:percent];
        
        [self objectsAchievmentIsComplete:achievement.identifier achievementTitle:@"Trash Man"];
        
        [self changeState:kStateHitBroward]; 
    } 
}
@end
