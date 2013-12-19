//
//  GameplayLayer.m
//  TerminalVelocity
//
//  Created by Aaron Jones on 6/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameplayLayer.h"
#import "Constants.h"
#import "GameManager.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.


@implementation GameplayLayer
@synthesize hudLayer;
@synthesize backgroundLayer;
@synthesize gameOverLayer;

-(void)setHudLayer:(HUDLayer *)h {
    if (hudLayer != h) {
        HUDLayer *t = hudLayer;
        hudLayer = [h retain];
        [t release];
        broward.delegate = hudLayer;
    }
}

-(void)dealloc {
    browardBody = NULL;
    if (world) {
        delete world;
        world = NULL;
    }
    
    if (debugDraw) {
        delete debugDraw;
        debugDraw = nil;
    }
    [objectManager removeAllObjects];
    [objectManager release];
    [broward release];
    [collisionObjectsSpriteBatchNode release];
    [browardSpriteBatchNode release];
    [hudLayer release];
    [backgroundLayer release];
    [gameOverLayer release];
    [super dealloc];
}

- (void)setupDebugDraw {
    debugDraw = new GLESDebugDraw(PTM_RATIO *[[CCDirector sharedDirector] contentScaleFactor]);
    world->SetDebugDraw(debugDraw);
    uint32 flags = 0;
    flags += b2DebugDraw::e_shapeBit;
    //		flags += b2DebugDraw::e_jointBit;
    //		flags += b2DebugDraw::e_aabbBit;
    //		flags += b2DebugDraw::e_pairBit;
    //		flags += b2DebugDraw::e_centerOfMassBit;
    debugDraw->SetFlags(flags);
}

-(void)initPhysics {
    // Define the gravity vector.
    b2Vec2 gravity;
    
    //gravity.Set(0.0f, -1.25f);
   
    //#if COCOS2D_DEBUG >= 1 
        gravity.Set(0.0f, 0.0f);//pin to top
    //#endif
    // Do we want to let bodies sleep?
    // This will speed up the physics simulation
    bool doSleep = false;
    
    // Construct a world object, which will hold and simulate the rigid bodies.
    world = new b2World(gravity, doSleep);
    
    world->SetContinuousPhysics(TRUE);
    
    //////////////////// Setup Debug Draw uncomment the draw method at bottom too!! ////////////////////
                                               // [self setupDebugDraw];
    
    
    
    // Define the ground body.
    b2BodyDef boundsBodyDef;
    boundsBodyDef.position.Set(0, 0); // bottom-left corner
    
    // Call the body factory which allocates memory for the ground body
    // from a pool and creates the ground box shape (also from a pool).
    // The body is also added to the world.
    boundsBody = world->CreateBody(&boundsBodyDef);
    
    // Define the ground box shape.
    b2PolygonShape boundsBox;		
    
    // bottom
    boundsBox.SetAsEdge(b2Vec2(0,0), b2Vec2(screenSize.width/PTM_RATIO,0));
    b2FixtureDef bottomFixtureDef;
    bottomFixtureDef.shape = &boundsBox;
    bottomFixtureDef.isSensor = true;
    boundsBody->CreateFixture(&bottomFixtureDef);
    
    // top
    boundsBox.SetAsEdge(b2Vec2(0,(screenSize.height - 25)/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,(screenSize.height -25)/PTM_RATIO));
    b2FixtureDef topFixtureDef;
    topFixtureDef.shape = &boundsBox;
    //topFixtureDef.isSensor = true;
    boundsBody->CreateFixture(&topFixtureDef);
    
    // left
    boundsBox.SetAsEdge(b2Vec2(1/PTM_RATIO,screenSize.height/PTM_RATIO), b2Vec2(1/PTM_RATIO,0));
    b2FixtureDef leftFixtureDef;
    leftFixtureDef.shape = &boundsBox;
    leftFixtureDef.isSensor = true;
    boundsBody->CreateFixture(&leftFixtureDef);
    
    // right
    boundsBox.SetAsEdge(b2Vec2((screenSize.width - 1)/PTM_RATIO,screenSize.height/PTM_RATIO), b2Vec2((screenSize.width - 1)/PTM_RATIO,0));
    b2FixtureDef rightFixtureDef;
    rightFixtureDef.shape = &boundsBox;
    rightFixtureDef.isSensor = true;
    boundsBody->CreateFixture(&rightFixtureDef);
     
}


-(void)loadSpriteSheetsAndBatchNodes {
    // broward sheets
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"broward_sprites.plist"];
    browardSpriteBatchNode = [[CCSpriteBatchNode batchNodeWithFile:@"broward_sprites.png"] retain];
    
    // collision items sheet
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"all_collision_items.plist"];
    collisionObjectsSpriteBatchNode = [[CCSpriteBatchNode batchNodeWithFile:@"all_collision_items.png"] retain ];
    
    // particle systems
    [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"asteroid-explode.plist"];
    [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"smoke.plist"];
    [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"birdexplosion.plist"];//bird yellow
    [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"birdexplosion2.plist"];//pigeon gray
    [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"flame.plist"];
    
    // space scene
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"space_scene_items.plist"];
    
    // sky and rain scene
    //[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"sky_scene_items.plist"];
    //[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"rain_scene_items.plist"];
    
    // city scene city_items-hd
    //[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"city_items.plist"];
    
    //cave scene
    //[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"cave_items.plist"];
    
    [self addChild:browardSpriteBatchNode z:kBrowardSpriteZValue tag:kBrowardSpriteTagValue];
    [self addChild:collisionObjectsSpriteBatchNode z:1 tag:2];
}

-(void)loadGameObjects {
    [self loadSpriteSheetsAndBatchNodes];
    broward = (Broward *)[objectManager addGameObjectWtihType:kBrowardSpace parentNode:browardSpriteBatchNode world:world delegate:hudLayer];
    [broward retain];
    browardBody = broward.body;
}

-(void)transitionToScene:(SceneTypes)type {
    switch (type) {
        case kSpaceScene:{
            [[GameObjectManager sharedGameObjectManager] removeAllGameObjects];
            [collisionObjectsSpriteBatchNode removeAllChildrenWithCleanup:YES];
            [objectManager createObjectsForScene:kSpaceScene parentNode:collisionObjectsSpriteBatchNode world:world delegate:hudLayer];
            [self scheduleUpdate];
            break;
        }
        case kSkyDayScene:{
            
            [[GameObjectManager sharedGameObjectManager] setObjectsForRemoval];

            browardBody->SetActive(false);
            id moveToTop = [CCMoveTo actionWithDuration:0.5f position:ccp(screenSize.width/2, screenSize.height - 100)];
            b2Vec2 pos;
            pos.Set(screenSize.width/2/PTM_RATIO, (screenSize.height - 100)/PTM_RATIO);
            browardBody->SetTransform(pos, 0);
            browardBody->SetLinearVelocity(b2Vec2_zero);
            [broward runAction:moveToTop];
            
            //get points when moving from space for unused rockets.
            if([hudLayer getActionCount]>0)
            {
                CGSize size = [CCDirector sharedDirector].winSize;
                [GameManager sharedGameManager].score += 50 *[hudLayer getActionCount];
                NSString *score = [[NSString alloc] initWithFormat:@"+%i You had %i rockets left!",(50 *[hudLayer getActionCount]),[hudLayer getActionCount]];
                
                CCLabelBMFont *scoreLabel = [CCLabelBMFont labelWithString:score fntFile:@"menus.fnt"];
       
                
                scoreLabel.position = ccp(size.width *.5, size.height *.5);
                [self addChild:scoreLabel];
                id fadeOut = [CCFadeOut actionWithDuration:4.0f];
                id remove = [CCCallBlockN actionWithBlock:^(CCNode *node){
                    [node removeFromParentAndCleanup:YES];
                }];
                [scoreLabel runAction:[CCSequence actions:fadeOut, remove, nil]];
                [score release];
            }
            
            break;
        }
        case kSkyNightScene:{
            //[[GameObjectManager sharedGameObjectManager] removeAllGameObjects];
            //[collisionObjectsSpriteBatchNode removeAllChildrenWithCleanup:YES];
            [[GameObjectManager sharedGameObjectManager] setObjectsForRemoval];
            [objectManager createObjectsForScene:kSkyNightScene parentNode:collisionObjectsSpriteBatchNode world:world delegate:hudLayer];
            break;
        }
        case kSkyRainScene:{
            //[[GameObjectManager sharedGameObjectManager] removeAllGameObjects];
            //[collisionObjectsSpriteBatchNode removeAllChildrenWithCleanup:YES];
            [[GameObjectManager sharedGameObjectManager] setObjectsForRemoval];
            [objectManager createObjectsForScene:kRainScene parentNode:collisionObjectsSpriteBatchNode world:world delegate:hudLayer];
            break;
        }
        case kCaveScene:{
            [[GameObjectManager sharedGameObjectManager] setObjectsForRemoval];
            [objectManager createObjectsForScene:kCaveScene parentNode:collisionObjectsSpriteBatchNode world:world delegate:hudLayer];
            break;
        }
        case kSkyDaySunsetScene: {
            [[GameObjectManager sharedGameObjectManager] setObjectsForRemoval];
            [objectManager createObjectsForScene:kSkyDayScene parentNode:collisionObjectsSpriteBatchNode world:world delegate:hudLayer];
            break;
        }
        case kCityScene: {
            //[[GameObjectManager sharedGameObjectManager] removeAllGameObjects];
            //[collisionObjectsSpriteBatchNode removeAllChildrenWithCleanup:YES];
            [[GameObjectManager sharedGameObjectManager] setObjectsForRemoval];
            [objectManager createObjectsForScene:kCityScene parentNode:collisionObjectsSpriteBatchNode world:world delegate:hudLayer];
            break;
        }
        case kSkyDayBreakScene: {
            //[[GameObjectManager sharedGameObjectManager] removeAllGameObjects];
            //[collisionObjectsSpriteBatchNode removeAllChildrenWithCleanup:YES];
            [[GameObjectManager sharedGameObjectManager] setObjectsForRemoval];
            [objectManager createObjectsForScene:kSkyDayScene parentNode:collisionObjectsSpriteBatchNode world:world delegate:hudLayer];
            break;
        }
        default:
            break;
    }
}

-(void)addGameObjectsForSky {
    [objectManager createObjectsForScene:kSkyDayScene parentNode:collisionObjectsSpriteBatchNode world:world delegate:hudLayer];
    browardBody->SetActive(true);
}

-(id)init {
    self = [super init];
    if (self != nil) {
        totalTime = 0.0f;
        screenSize = [CCDirector sharedDirector].winSize;
        zeroHeight = screenSize.height - 100.0f;
		
		// enable accelerometer
		self.isAccelerometerEnabled = YES;
        [[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0/40.0)];
        [self initPhysics];
        objectManager = [[GameObjectManager sharedGameObjectManager] retain];
    }
    return self;
}

//#define FILTERFACTOR 0.01
static double dt = 1.0 / 60.0;
static double RC = 1.0 / 5.0;
static double filterConstant = dt / (dt + RC);
static double opFilterConstant = 1.0 - filterConstant;
static UIAccelerationValue accelValueX = 0;
static UIAccelerationValue accelValueXPrev = 0;
static UIAccelerationValue currentAccelX = 0;

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)accel {
    
    // manuall
    currentAccelX = (accel.x * filterConstant) + (accelValueXPrev * opFilterConstant);
    
    if (currentAccelX < 0.18 && currentAccelX > -0.18) {
        accelValueX = currentAccelX;
        accelValueXPrev = accelValueX;
    }
}


#pragma mark –
#pragma mark Update Method
static GameManager *gameManager = [GameManager sharedGameManager];
-(void)update:(ccTime)deltaTime {
    // debug only set to false normal gameplay set to true
    //browardBody->SetActive(false);
    
    if (gameManager.hasPlayerDied) {
        [self.parent getChildByTag:96].visible = YES;
        hudLayer.visible = NO;
        [self unscheduleUpdate];
    }
    
    
    static b2Vec2 downForce;
    
    // value history
    // original -1.3 
    downForce.Set(0,(-1.4f + [GameManager sharedGameManager].difficultyLevel));////1.05 was debug value
    
    //unpin to top //pin to top
    #if COCOS2D_DEBUG == 0 
        browardBody->ApplyForce(downForce, browardBody->GetPosition());
    #endif
    
    
    if (accelValueX  < -0.02f) {
        [broward setFlipX:NO];
    } else if (accelValueX  > 0.02f)  {
        [broward setFlipX:YES];
    }
    
    static b2Vec2 vel;
    b2Vec2 origVel = browardBody->GetLinearVelocity();
    vel.Set(40 * accelValueX, origVel.y);
    browardBody->SetLinearVelocity(vel);
    
    totalTime += deltaTime;
    
	
    static double UPDATE_INTERVAL = 1.0f/60.0f;
    
    // value history
    // 5
    static double MAX_CYCLES_PER_FRAME = 3;
    static double timeAccumulator = 0;
    
    timeAccumulator += deltaTime;    
    if (timeAccumulator > (MAX_CYCLES_PER_FRAME * UPDATE_INTERVAL)) {
        timeAccumulator = UPDATE_INTERVAL;
    }    
    
    static int32 velocityIterations = 3;
    static int32 positionIterations = 2;
    while (timeAccumulator >= UPDATE_INTERVAL) {        
        timeAccumulator -= UPDATE_INTERVAL;
        world->Step(UPDATE_INTERVAL, velocityIterations, positionIterations);
    }
    
	//Iterate over the bodies in the physics world
    //int bodyCount =0;
	for(b2Body *b = world->GetBodyList(); b != NULL; b = b->GetNext()) {    
        if (b->GetUserData() != NULL && b->IsActive()) {
            Box2DSprite *sprite = (Box2DSprite *)b->GetUserData();
                sprite.position = ccp(b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
                sprite.rotation = CC_RADIANS_TO_DEGREES(b->GetAngle() * -1);
        }
        //bodyCount++;
    }
    
    //CCLOG(@"BODY COUNT=%i", bodyCount);
    
    [hudLayer updateHUD:deltaTime pos:broward.position];
    [backgroundLayer updateScroll:deltaTime pos:broward.position];
    
    CCArray *listOfGameObjects = objectManager->objectList;
    GameCharacter *tempChar = nil;
    CCARRAY_FOREACH(listOfGameObjects, tempChar) {
        //if (tempChar.isActive) {
            [tempChar updateStateWithDeltaTime:deltaTime andListOfGameObjects:listOfGameObjects];
        //}
    }
    
    
}


/*
-(void)draw {
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	world->DrawDebugData();
	
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
}*/

@end
