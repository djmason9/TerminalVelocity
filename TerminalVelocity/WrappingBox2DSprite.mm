//
//  WrappingBox2DSprite.mm
//  TerminalVelocity
//
//  Created by Aaron Jones on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WrappingBox2DSprite.h"
#import "GameManager.h"

@implementation WrappingBox2DSprite


/*

-(void)setParent:(CCNode *)node {
    [super setParent:node];
    //[node addChild:mirroredSprite z:0];
}

-(void)setFlipX:(BOOL)flip {
    if (characterState != kStateActionButtonPressed) {
        [super setFlipX:flip];
        //[mirroredSprite setFlipX:flip];
    }
    
}

-(CCAction*)runAction:(CCAction *)action {
    [super runAction:action];
    //[mirroredSprite runAction:[action copy]];
    return action;
}
*/

-(BOOL)isObjectOffScreen {
    CGPoint p = self.position;
    
    if (p.y > screenSize.height) {
        return  YES;
    } else {
        return  NO;
    }
}

/*
-(void)setPosition:(CGPoint)p {
    [super setPosition:p];
    //mirroredSprite.position = p;
}
*/
-(void)checkAndClampSpritePosition {
    CGPoint currentSpritePosition = [self position];
    static CGSize levelSize = [[GameManager sharedGameManager] getDimensionsOfCurrentScene];
    CGSize box = self.boundingBox.size;
    static float xOffset = -1*box.width/2;
    static float xOffsetRight = levelSize.width - xOffset;
    static b2Vec2 newPos;
    
    if (currentSpritePosition.x < xOffset && body->IsActive()) {
        b2Vec2 origPos = body->GetPosition();
        newPos.Set(xOffsetRight/PTM_RATIO, origPos.y);
        body->SetTransform(newPos, 0);
        [self setPosition:ccp(xOffsetRight, origPos.y)];
    } else if (currentSpritePosition.x > xOffsetRight && body->IsActive()) {
        b2Vec2 origPos = body->GetPosition();
        newPos.Set(xOffset/PTM_RATIO, origPos.y);
        body->SetTransform(newPos, 0);
        [self setPosition:ccp(xOffset, origPos.y)];
    }
}

/*
-(void)checkAndClampSpritePosition {
    CGPoint currentSpritePosition = [self position];
    
    static CGSize levelSize = [[GameManager sharedGameManager] getDimensionsOfCurrentScene];
    CGSize box = self.boundingBox.size;
    static float xOffset = box.width/2;
    static float xOffsetRight = levelSize.width - xOffset;
    static b2Vec2 newPos;
    
    if (currentSpritePosition.x < xOffset && currentSpritePosition.x > ((-1*(xOffset))) && body->IsActive()) {
        // 
        //mirroredSprite.visible = YES;
        mirroredSprite.position = ccp(levelSize.width + currentSpritePosition.x, currentSpritePosition.y);
        
    } else if (currentSpritePosition.x <= ((-1*(xOffset))) ) {
        //mirroredSprite.visible = NO;
        b2Vec2 origPos = body->GetPosition();
        newPos.Set((levelSize.width - (xOffset))/PTM_RATIO, origPos.y);
        body->SetTransform(newPos, 0);
    } else if (currentSpritePosition.x > xOffsetRight && currentSpritePosition.x < (levelSize.width + xOffset) && body->IsActive()) {
        //mirroredSprite.visible = YES;
        mirroredSprite.position = ccp(currentSpritePosition.x - levelSize.width, currentSpritePosition.y);
        
    } else if (currentSpritePosition.x >= (levelSize.width + xOffset) ) {
        //mirroredSprite.visible = NO;
        b2Vec2 origPos = body->GetPosition();
        newPos.Set(xOffset/PTM_RATIO, origPos.y);
        body->SetTransform(newPos, 0);
       
    } else {
        mirroredSprite.position = currentSpritePosition;
    }
    
}
*/
@end
