//
//  SkyCloudsLayer.m
//  TerminalVelocity
//
//  Created by Aaron Jones on 9/4/11.
//  Copyright (c) 2011 Dark Energy Studios. All rights reserved.
//

#define boris_random(smallNumber, bigNumber) ((((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * (bigNumber - smallNumber)) + smallNumber)

#import "SkyCloudsLayer.h"
#import "SkyCloud.h"

@implementation SkyCloudsLayer
@synthesize cloudType;

- (void)dealloc {
    [spriteBatchNode release];
    [frontClouds release];
    [backClouds release];
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        cloudType = kSkyWhiteCloud;
        screenSize = [CCDirector sharedDirector].winSize;
        spriteBatchNode = [[CCSpriteBatchNode batchNodeWithFile:@"sky_scene_items.png"] retain];
        frontClouds = [[CCArray arrayWithCapacity:3] retain];
        backClouds = [[CCArray arrayWithCapacity:3] retain];
        [self addChild:spriteBatchNode];
    }
    return self;
}

-(void)setCloudType:(SkyCloudTypes)type {
    cloudType = type;
    [spriteBatchNode removeFromParentAndCleanup:YES];
    [spriteBatchNode release];
    spriteBatchNode = nil;
    switch (type) {
        case kSkyWhiteCloud: {
            spriteBatchNode = [[CCSpriteBatchNode batchNodeWithFile:@"sky_scene_items.png"] retain];
            break;
        }
        case kSkyGrayCloud: {
            spriteBatchNode = [[CCSpriteBatchNode batchNodeWithFile:@"rain_scene_items.png"] retain];
            break;
        }
        default:
            break;
    }
    [self addChild:spriteBatchNode];
     
}

-(void)createClouds {
    for (int x=0; x <= 6; x++) {
        [self createCloudFront];
        
    }
    
    
    [self updateFrontCloudsPosition:10.0f];
    
    for (int x=0; x <= 9; x++) {
        [self createCloudBack];
        
    }
    
    [self updateBackCloudsPosition:10.0f];
    
    for (int x=0; x < 10; x++) {
        [self updateFrontCloudsPosition:10.0f];
        [self updateBackCloudsPosition:10.0f];
    }
}

-(void)updateBackCloudsPosition:(float)rate {
    SkyCloud *cloud = nil;
    CCARRAY_FOREACH(backClouds, cloud) {
        float yOffSet = [cloud boundingBox].size.height/2;
        float offScreenYPosition = (screenSize.height + 1 + yOffSet);
        cloud.position = ccp(cloud.position.x, cloud.position.y + (cloud->rate * rate));
        if (cloud.position.y  >= offScreenYPosition) {
            int yPosition = (-1 * yOffSet) - (arc4random() % 480);
            int xPosition = arc4random() % (int)screenSize.width;
            cloud->rate = boris_random(0.4, 1.0);
            [cloud setPosition:ccp(xPosition,yPosition)];
        }
    }
}

-(void)updateFrontCloudsPosition:(float)rate {
    SkyCloud *cloud = nil;
    CCARRAY_FOREACH(frontClouds, cloud) {
        float yOffSet = [cloud boundingBox].size.height/2;
        float offScreenYPosition = (screenSize.height + 1 + yOffSet);
        cloud.position = ccp(cloud.position.x, cloud.position.y + (cloud->rate * rate));
        if (cloud.position.y  >= offScreenYPosition) {
            int yPosition = (-1 * yOffSet) - (arc4random() % 480);
            int xPosition = arc4random() % (int)screenSize.width;
            cloud->rate = boris_random(1.5, 3.0);
            [cloud setPosition:ccp(xPosition,yPosition)];
        }
    }
}

-(NSString *)stringForBackSpriteName {
    switch (cloudType) {
        case kSkyWhiteCloud:
            return @"back_%d.png";
        case kSkyGrayCloud:
            return @"r_back_%d.png";
        default:
            return nil;
    }
}
-(NSString *)stringForFrontSpriteName {
    switch (cloudType) {
        case kSkyWhiteCloud:
            return @"front_%d.png";
        case kSkyGrayCloud:
            return @"r_front_%d.png";
        default:
            return nil;
    }
}

-(void)createCloudBack {
    int cloudToDraw = arc4random() % 3;
    NSString *spriteName = [self stringForBackSpriteName];
    NSString *cloudFileName = [NSString stringWithFormat:spriteName,cloudToDraw];
    SkyCloud *cloudSprite = [SkyCloud spriteWithSpriteFrameName:cloudFileName];
    [spriteBatchNode addChild:cloudSprite];
    [backClouds addObject:cloudSprite];
    
    float yOffSet = [cloudSprite boundingBox].size.height/2;
    int yPosition = (-1 * yOffSet) - (arc4random() % 480);
    int xPosition = arc4random() % (int)screenSize.width;
    cloudSprite->rate = boris_random(0.4, 1.0);
    
    [cloudSprite setPosition:ccp(xPosition,yPosition)];
}

-(void)createCloudFront {
    int cloudToDraw = arc4random() % 3;
    NSString *spriteName = [self stringForFrontSpriteName];
    NSString *cloudFileName = [NSString stringWithFormat:spriteName,cloudToDraw];
    SkyCloud *cloudSprite = [[SkyCloud spriteWithSpriteFrameName:cloudFileName] retain];
    [spriteBatchNode addChild:cloudSprite];
    [frontClouds addObject:cloudSprite];
    
    float yOffSet = [cloudSprite boundingBox].size.height/2;
    
    int yPosition = (-1 * yOffSet) - (arc4random() % 480);
    int xPosition = arc4random() % (int)screenSize.width;
    cloudSprite->rate = boris_random(1.5, 3.0);
    [cloudSprite setPosition:ccp(xPosition,yPosition)];
}

-(void)updateScroll:(ccTime)deltaTime pos:(CGPoint)pos {
    
}
@end
