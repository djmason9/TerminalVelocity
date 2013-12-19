//
//  GameObjectManager.m
//  TerminalVelocity
//
//  Created by Aaron Jones on 7/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameObjectManager.h"
#import "GameplayLayer.h"
#import "GameObject.h"
#import "Asteroid.h"
#import "AlienShip.h"
#import "Trash.h"
#import "Satellite.h"
#import "Bird.h"
#import "Pigeon.h"
#import "Bat.h"
#import "Owl.h"
#import "GlowBug.h"
#import "Pig.h"
#import "Gargoyle.h"
#import "Firework.h"
#import "Roots.h"
#import "Bees.h"
#import "Lightning.h"
#import "Reload.h"
#import "ReloadRocket.h"
#import "Plane.h"
#import "Blimp.h"
#import "Umbrella.h"
#import "Bra.h"

@implementation GameObjectManager
static GameObjectManager *_sharedGameObjectManager = nil;

-(void)dealloc {
    [objectList release];
    [super dealloc];
}


+(GameObjectManager *)sharedGameObjectManager {
    @synchronized([GameObjectManager class]) {
        if (!_sharedGameObjectManager) {
            [[self alloc] init];
        }
        return _sharedGameObjectManager;
    }
    return nil;
}

+(id)alloc {
    @synchronized([GameObjectManager class]) {
        NSAssert(_sharedGameObjectManager == nil, @"Only one instance of GameObjectManager");
        _sharedGameObjectManager = [super alloc];
        return _sharedGameObjectManager;
    }
    return nil;
}


- (id)init {
    self = [super init];
    if (self) {
        screenSize = [CCDirector sharedDirector].winSize;
        objectList = [[CCArray alloc] initWithCapacity:10];
    }
    return self;
}

-(void)createObjectsForScene:(SceneTypes)type parentNode:(CCNode *)parentNode world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate {
    switch (type) {
        case kSpaceScene: {
            [self addAsteroidsToNode:parentNode world:world delegate:delegate];
            [self addAlienShip:parentNode world:world delegate:delegate];
            [self addGameObjectWtihType:kSatilite parentNode:parentNode world:world delegate:delegate];
            [self addGameObjectWtihType:kTrash parentNode:parentNode world:world delegate:delegate];
            [self addReloadRocketToNode:parentNode world:world delegate:delegate];
            break;
        }
        case kSkyDayScene: {
            [self addBirdToNode:parentNode world:world delegate:delegate];
            [self addPigToNode:parentNode world:world delegate:delegate];
            [self addBeesToNode:parentNode world:world delegate:delegate];
            [self addReloadToNode:parentNode world:world delegate:delegate];
            [self addPlaneToNode:parentNode world:world delegate:delegate];
            break;
        }
        case kSkyNightScene:{
            [self addRocketToNode:parentNode world:world delegate:delegate];
            [self addBatToNode:parentNode withCount:3 world:world delegate:delegate];
            [self addOwlToNode:parentNode world:world delegate:delegate];
            [self addGlowBugToNode:parentNode world:world delegate:delegate];
            [self addReloadToNode:parentNode world:world delegate:delegate];
            [self addBlimpToNode:parentNode world:world delegate:delegate ];
            break;
        }
        case kRainScene:{
            [self addPigeonToNode:parentNode world:world delegate:delegate];
            [self addLightningToNode:parentNode world:world delegate:delegate];
            [self addReloadToNode:parentNode world:world delegate:delegate];
            [self addUmbrellaToNode:parentNode world:world delegate:delegate];
            break;
        }
        case kCityScene:{
            [self addBraToNode:parentNode world:world delegate:delegate];
            [self addGargoyleToNode:parentNode world:world delegate:delegate];
            [self addPigeonToNode:parentNode world:world delegate:delegate];
            [self addReloadToNode:parentNode world:world delegate:delegate];
            break;
        }
        case kCaveScene:{
            [self addBatToNode:parentNode withCount:5 world:world delegate:delegate];
            [self addRootToNode:parentNode world:world delegate:delegate];
            [self addReloadToNode:parentNode world:world delegate:delegate];
            
            break;
        }
        default:
            break;
    }
}

-(void)setObjectsForRemoval {
    GameCharacter *tempChar = nil;
    int count = 0;
    CCARRAY_FOREACH(objectList, tempChar) {
        if (count == 0) {
            count = 1;
            continue;
        }
        tempChar.removeObject = YES;
        tempChar.isActive = NO;
        id fadeOut = [CCFadeOut actionWithDuration:1.0f];
        id remove = [CCCallBlockN actionWithBlock:^(CCNode *node){
            CCLOG(@"REMOVE %@ GAME OBJECT FROM CACHE", [node class]);
            [self removeGameObject:node];
            [node removeFromParentAndCleanup:YES];
        }];
        [tempChar runAction:[CCSequence actions:fadeOut, remove, nil]];
    }
}
#pragma mark -
#pragma mark Object Methods

-(void)addBatToNode:(CCNode *)parentNode withCount:(int)count world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate {
    for (int i = 0; i < count; i++) {
        [self addGameObjectWtihType:kBat parentNode:parentNode world:world delegate:delegate];
    }
}
-(void)addGargoyleToNode:(CCNode *)parentNode world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate {
    for (int i = 0; i < 2; i++) {
        [self addGameObjectWtihType:kGargoyle parentNode:parentNode world:world delegate:delegate];
    }
}

-(void)addReloadToNode:(CCNode *)parentNode world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate {
    for (int i = 0; i < 1; i++) {
        [self addGameObjectWtihType:kReload parentNode:parentNode world:world delegate:delegate];
    }
}
-(void)addReloadRocketToNode:(CCNode *)parentNode world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate {
    for (int i = 0; i < 1; i++) {
        [self addGameObjectWtihType:kReloadRocket parentNode:parentNode world:world delegate:delegate];
    }
}

-(void)addOwlToNode:(CCNode *)parentNode world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate {
    for (int i = 0; i < 3; i++) {
        [self addGameObjectWtihType:kOwl parentNode:parentNode world:world delegate:delegate];
    }
}

-(void)addUmbrellaToNode:(CCNode *)parentNode world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate {
    for (int i = 0; i < 1; i++) {
        [self addGameObjectWtihType:kUmbrella parentNode:parentNode world:world delegate:delegate];
    }
}

-(void)addBraToNode:(CCNode *)parentNode world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate {
    for (int i = 0; i < 3; i++) {
        [self addGameObjectWtihType:kBra parentNode:parentNode world:world delegate:delegate];
    }
}


-(void)addLightningToNode:(CCNode *)parentNode world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate {
    for (int i = 0; i < 1; i++) {
        [self addGameObjectWtihType:kLightning parentNode:parentNode world:world delegate:delegate];
    }
}

-(void)addRootToNode:(CCNode *)parentNode world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate {
    for (int i = 0; i < 4; i++) {
        [self addGameObjectWtihType:kRoot parentNode:parentNode world:world delegate:delegate];
    }
}

-(void)addRocketToNode:(CCNode *)parentNode world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate {
    for (int i = 0; i < 1; i++) {
        [self addGameObjectWtihType:kFirework parentNode:parentNode world:world delegate:delegate];
    }
}

-(void)addBeesToNode:(CCNode *)parentNode world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate {
    for (int i = 0; i < 1; i++) {
        [self addGameObjectWtihType:kBees parentNode:parentNode world:world delegate:delegate]; 
    }
        
}

-(void)addGlowBugToNode:(CCNode *)parentNode world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate {
    for (int i = 0; i < 3; i++) {
        [self addGameObjectWtihType:kGlowBug parentNode:parentNode world:world delegate:delegate];
    }
}

-(void)addBirdToNode:(CCNode *)parentNode world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate {
    for (int i = 0; i < 6; i++) {
        [self addGameObjectWtihType:kBird parentNode:parentNode world:world delegate:delegate];
    }
}

-(void)addPigeonToNode:(CCNode *)parentNode world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate {
    for (int i = 0; i < 5; i++) {
        [self addGameObjectWtihType:kPigeon parentNode:parentNode world:world delegate:delegate];
    }
}

-(void)addPigToNode:(CCNode *)parentNode world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate {
    for (int i = 0; i < 1; i++) {
        [self addGameObjectWtihType:kPig parentNode:parentNode world:world delegate:delegate];
    }
}

-(void)addAsteroidsToNode:(CCNode *)parentNode world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate {
    
    for (int i = 0; i < 5; i++) {
        [self addGameObjectWtihType:kAsteroid parentNode:parentNode world:world delegate:delegate];
    }
}

-(void)addAlienShip:(CCNode *)parentNode world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate {
        [self addGameObjectWtihType:kAlienShip parentNode:parentNode world:world delegate:delegate];
}

-(void)addPlaneToNode:(CCNode *)parentNode world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate{
    for (int i = 0; i < 1; i++) {
        [self addGameObjectWtihType:kPlane parentNode:parentNode world:world delegate:delegate];
    }
}
-(void)addBlimpToNode:(CCNode *)parentNode world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate{
    for (int i = 0; i < 1; i++) {
        [self addGameObjectWtihType:kBlimp parentNode:parentNode world:world delegate:delegate];
    }
}

-(void)addSatilite:(CCNode *)parentNode world:(b2World *)world {
    
}
#pragma mark -

-(void)removeAllGameObjects {
    id broward = [[objectList objectAtIndex:0] retain];
    [objectList removeAllObjects];
    [objectList addObject:broward];
    [broward release];
}

-(void)removeAllObjects {
    [objectList removeAllObjects];
}

-(void)removeGameObject:(CCNode *)node {
    //CCLOG(@"Number of Game Objects in List=%i",[objectList count]);
    [objectList removeObject:node];
}

-(GameObject *)addGameObjectWtihType:(GameObjectType)type parentNode:(CCNode *)parentNode world:(b2World *)world delegate:(id<GameplayLayerDelegate>)delegate {
    Box2DSprite *gameObject = nil;
    switch (type) {
        case kBrowardSpace: {
            gameObject = [[Broward alloc] initWithWorld:world atLocation:CGPointMake(screenSize.width/2, screenSize.height - 80)];
            gameObject.sceneType = kSpaceScene;
            break;
        }
        case kBrowardSky: {
            gameObject = [[Broward alloc] initWithWorld:world atLocation:CGPointMake(screenSize.width/2, screenSize.height - 50)];
            gameObject.sceneType = kSkyDayScene;
            break;
        }
        case kAsteroid: {
            gameObject = [[Asteroid alloc] initRandomInWorld:world];
            break;
        }
        case kAlienShip: {
            gameObject = [[AlienShip alloc] initRandomInWorld:world];
            break;
        }
        case kSatilite: {
            gameObject = [[Satellite alloc] initRandomInWorld:world];
            break;
        }
        case kTrash:{
            gameObject = [[Trash alloc] initRandomInWorld:world];
            break;        
        }
        case kBird: {
            gameObject = [[Bird alloc] initRandomInWorld:world];
            break;
        }  
        case kBat: {
            gameObject = [[Bat alloc] initRandomInWorld:world];
            break;
        }  
        case kGlowBug: {
            gameObject = [[GlowBug alloc] initRandomInWorld:world];
            break;
        }  
        case kPigeon: {
            gameObject = [[Pigeon alloc] initRandomInWorld:world];
            break;
        }
        case kPig: {
            gameObject = [[Pig alloc] initRandomInWorld:world];
            break;
        }
        case kOwl: {
            gameObject = [[Owl alloc] initRandomInWorld:world];
            break;
        }
        case kFirework:{
            gameObject = [[Firework alloc] initRandomInWorld:world];
            break;
        }
        case kGargoyle:{
            gameObject = [[Gargoyle alloc] initRandomInWorld:world];
            break;
        }
        case kRoot:{
            gameObject = [[Roots alloc] initRandomInWorld:world];
            break;
        }
        case kBees:{
            gameObject = [[Bees alloc] initRandomInWorld:world];
            break;
        }
        case kLightning:{
            gameObject = [[Lightning alloc] initRandomInWorld:world];
            break;
        }
        case kReload:{
            gameObject = [[Reload alloc] initRandomInWorld:world];
            break;
        }
        case kReloadRocket:{
            gameObject = [[ReloadRocket alloc] initRandomInWorld:world];
            break;
        } 
        case kPlane:{
            gameObject = [[Plane alloc] initRandomInWorld:world];
            break;
        }
        case kBlimp:{
            gameObject = [[Blimp alloc] initRandomInWorld:world];
            break;
        }
        case kUmbrella:{
            gameObject = [[Umbrella alloc] initRandomInWorld:world];
            break;
        }
        case kBra:{
            gameObject = [[Bra alloc] initRandomInWorld:world];
            break;
        }
        default:
            break;
    }
    
    if (gameObject) {
        gameObject.delegate = delegate;
        if (type == kBrowardSpace) {
            [parentNode addChild:gameObject z:5];
        } else {
            [parentNode addChild:gameObject];
        }
        
        [objectList addObject:gameObject];
        [gameObject autorelease];
        gameObject.gameObjectManager = self;
    }
    return  gameObject;
}

@end
