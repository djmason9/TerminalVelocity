//
//  SkyCloudsLayer.h
//  TerminalVelocity
//
//  Created by Aaron Jones on 9/4/11.
//  Copyright (c) 2011 Dark Energy Studios. All rights reserved.
//

#import "cocos2d.h"

typedef enum {
    kSkyWhiteCloud=0,
    kSkyGrayCloud=1
} SkyCloudTypes;

@interface SkyCloudsLayer : CCLayer {
    SkyCloudTypes cloudType;
    CGSize screenSize;
    CCSpriteBatchNode *spriteBatchNode;
    CCArray *frontClouds;
    CCArray *backClouds;
}
@property(readwrite) SkyCloudTypes cloudType;
-(void)updateBackCloudsPosition:(float)rate;
-(void)updateFrontCloudsPosition:(float)rate;
-(void)createCloudBack;
-(void)createCloudFront;
-(void)createClouds;
-(void)updateScroll:(ccTime)deltaTime pos:(CGPoint)pos;
@end
