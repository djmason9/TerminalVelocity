//
//  Broward.h
//  TerminalVelocity
//
//  Created by Aaron Jones on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WrappingBox2DSprite.h"

@interface Broward : WrappingBox2DSprite {
    CCSprite *removedSpaceSuit;
    float actionTime;
//    int numActionItems;
    CCAnimation *fallingAnim;
    CCAnimation *fallingSkyAnim;
    CCAnimation *burningAnim;
    CCAnimation *beeAttackAnim;
    CCAnimation *bounceAnim;
    CCAnimation *bounceSkyAnim;
    CCAnimation *jetpackRepeatAnim;
    CCAnimation *parachuteOnceAnim;
    CCAnimation *parachuteRepeatAnim;
    //night
    CCAnimation *nightParachuteRepeatAnim;
    CCAnimation *nightParachuteOnceAnim;
    CCAnimation *nightFallingSkyAnim;
    CCAnimation *nightBounceSkyAnim;
    
    CCParticleSystem *smokingEmitter;

}
@property (nonatomic, retain) CCAnimation *fallingAnim;
@property (nonatomic, retain) CCAnimation *fallingSkyAnim;
@property (nonatomic, retain) CCAnimation *burningAnim;
@property (nonatomic, retain) CCAnimation *beeAttackAnim;
@property (nonatomic, retain) CCAnimation *bounceAnim;
@property (nonatomic, retain) CCAnimation *bounceSkyAnim;
@property (nonatomic, retain) CCAnimation *jetpackRepeatAnim;
@property (nonatomic, retain)  CCAnimation *parachuteOnceAnim;
@property (nonatomic, retain) CCAnimation *parachuteRepeatAnim;
@property (nonatomic, retain) CCSprite *removedSpaceSuit;

//night
@property (nonatomic, retain) CCAnimation *nightParachuteRepeatAnim;
@property (nonatomic, retain) CCAnimation *nightParachuteOnceAnim;
@property (nonatomic, retain) CCAnimation *nightFallingSkyAnim;
@property (nonatomic, retain) CCAnimation *nightBounceSkyAnim;

-(void)startFallingAnim;
-(void)startActionButtonAction;
-(void)stopActionButtonAction;
-(void)removeSpaceSuitAnim;
@end

/*
@interface BrowardSky : Broward {
  
}
@end

@interface BrowardSpace : Broward {

}
@end

*/
