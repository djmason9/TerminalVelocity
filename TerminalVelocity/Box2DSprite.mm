//
//  Box2DSprite.mm
//  TerminalVelocity
//
//  Created by Aaron Jones on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Box2DSprite.h"
#import "GameObjectManager.h"


@implementation Box2DSprite
@synthesize body;

- (void)dealloc {
    [self cleanup];
    [super dealloc];
}


-(id)initRandomInWorld:(b2World *)world {
    self = [super init];
    if (self) {
        body = NULL;
    }
    return self;
}


-(id)initWithWorld:(b2World *)world atLocation:(CGPoint)location {
    self = [super init];
    if (self) {
        body = NULL;
    }
    return self;
}

-(void)setIsActive:(BOOL)active {
    isActive = active;
    if (body) {
        body->SetActive(active);
    }
}

-(void)cleanup {
    if (body) {
        body->SetActive(false);
        body->GetWorld()->DestroyBody(body);
        body = NULL;
    }
}

-(void)resetObject {
    if (removeObject) {
        [gameObjectManager removeGameObject:self];
        [self removeFromParentAndCleanup:YES];
    }
    
}
-(void)startObject {
    
}


-(void)checkAndClampSpritePosition {
    CGPoint currentSpritePosition = [self position];
    
    CGSize levelSize = [[GameManager sharedGameManager] getDimensionsOfCurrentScene];
    float xOffset;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // Clamp for the iPad
        xOffset = 30.0f;
    } else {
        // Clamp for iPhone, iPhone 4, or iPod touch
        xOffset = 24.0f;
    }
    
    if (currentSpritePosition.x < 0 && body->IsActive()) {
        //[self setPosition:ccp(levelSize.width, currentSpritePosition.y)];
        b2Vec2 vel;
        b2Vec2 origPos = body->GetPosition();
        
        vel.Set(levelSize.width/PTM_RATIO, origPos.y);
        body->SetTransform(vel, 0);
    } else if (currentSpritePosition.x > levelSize.width && body->IsActive()) {
        //[self setPosition:ccp((levelSize.width - xOffset), currentSpritePosition.y)];
        b2Vec2 vel;
        b2Vec2 origPos = body->GetPosition();
        
        vel.Set(0, origPos.y);
        body->SetTransform(vel, 0);
    }
}

// Override if necessary
- (BOOL)mouseJointBegan {
    return TRUE;
}
@end
