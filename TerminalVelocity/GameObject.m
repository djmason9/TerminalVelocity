//
//  GameObject.m
//  TerminalVelocity
//
//  Created by Aaron Jones on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"
#import "GameManager.h"
#import "GameObjectManager.h"

@implementation GameObject
@synthesize delegate;
@synthesize reactsToScreenBoundaries;
@synthesize screenSize;
@synthesize isActive;
@synthesize gameObjectType;
@synthesize sceneType;
@synthesize removeObject;
@synthesize gameObjectManager;
@synthesize characterState; 

-(void)dealloc {
    delegate = nil;
    [super dealloc];
}

-(id) init {
    if((self=[super init])){
        screenSize = [CCDirector sharedDirector].winSize;
        isActive = NO;
        removeObject = NO;
        gameObjectType = kObjectTypeNone;
        prefs = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

-(BOOL)isObjectOffScreen {
    CGPoint p = self.position;
    
    if ((p.x < 0 || p.x > screenSize.width || p.y > screenSize.height) && characterState == kStateMoving) {
        return  YES;
    } else {
        return  NO;
    }
}


-(void)objectsAchievmentIsComplete:(NSString*) achievementKey achievementTitle:(NSString *)title{
    
    NSString *sysVer = [[UIDevice currentDevice] systemVersion];
    float sysVerFloat = [sysVer floatValue];
    
    GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper]; 
    
    NSString *userKey = [prefs stringForKey:achievementKey];
    
    GKAchievement* achievement = [gkHelper getAchievementByID:achievementKey];
    
    if (achievement.completed && ![userKey isEqualToString:@"true"]) 
    {
        if (sysVerFloat >= 5.0) 
            achievement.showsCompletionBanner =YES;
        else
        {
            CGSize size = [CCDirector sharedDirector].winSize;
            NSString *achievmentString = [NSString stringWithFormat:@"+50 %@ Complete",title];
            
            CCLabelBMFont *scoreLabel = [CCLabelBMFont labelWithString:achievmentString fntFile:@"menus.fnt"];
            scoreLabel.position = ccp(size.width *.5, size.height *.5);
            [self.parent.parent addChild:scoreLabel];
            
            id fadeOut = [CCFadeOut actionWithDuration:2.5f];
            id remove = [CCCallBlockN actionWithBlock:^(CCNode *node){
                //CCLOG(@"REMOVE ALIEN SCORE LABEL");
                [node removeFromParentAndCleanup:YES];
            }];
            [scoreLabel runAction:[CCSequence actions:fadeOut, remove, nil]];
        }
        
        [prefs setObject:@"true" forKey:achievementKey];
        [GameManager sharedGameManager].score += 50;
        
    }else if (sysVerFloat >= 5.0) 
        achievement.showsCompletionBanner=NO;
    
}

-(void)changeState:(CharacterStates)newState {
    //CCLOG(@"GameObject->changeState method should be overriden");
}

-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects {
    //CCLOG(@"updateStateWithDeltaTime method should be overriden");
}

-(CGRect)adjustedBoundingBox {
   // CCLOG(@"GameObect adjustedBoundingBox should be overriden");
    return [self boundingBox];
}
-(CCAnimation*)loadPlistForAnimationWithName:(NSString*)animationName andClassName:(NSString*)className {
    
    CCAnimation *animationToReturn = nil;
    NSString *fullFileName = 
    [NSString stringWithFormat:@"%@.plist",className];
    NSString *plistPath;
    
    // 1: Get the Path to the plist file
    NSString *rootPath = 
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:fullFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] 
                     pathForResource:className ofType:@"plist"];
    }
    
    // 2: Read in the plist file
    NSDictionary *plistDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    // 3: If the plistDictionary was null, the file was not found.
    if (plistDictionary == nil) {
        CCLOG(@"Error reading plist: %@.plist", className);
        return nil; // No Plist Dictionary or file found
    }
    
    // 4: Get just the mini-dictionary for this animation
    NSDictionary *animationSettings = [plistDictionary objectForKey:animationName];
    if (animationSettings == nil) {
        CCLOG(@"Could not locate AnimationWithName:%@",animationName);
        return nil;
    }
    
    // 5: Get the delay value for the animation
    float animationDelay = [[animationSettings objectForKey:@"delay"] floatValue];
    
    // 6: Add the frames to the animation
    NSString *animationFramePrefix = [animationSettings objectForKey:@"filenamePrefix"];
    NSString *animationFrames = [animationSettings objectForKey:@"animationFrames"];
    NSRange range = [animationFrames rangeOfString:@"-"];
    NSMutableArray *frames = [NSMutableArray array];
    if (range.location != NSNotFound) {
        int s1 = [[animationFrames substringToIndex:range.location] intValue];
        int s2 = [[animationFrames substringFromIndex:(range.location + 1)] intValue];
        for (int i = s1; i <= s2; i++) {
            NSString *frameName = [NSString stringWithFormat:@"%@%05d.png", animationFramePrefix, i];
            //[animationToReturn addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:fileName]];
            [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
        }
    } else {
        NSArray *animationFrameNumbers = [animationFrames componentsSeparatedByString:@","];
        for (NSString *frameNumber in animationFrameNumbers) {
            int i = [frameNumber intValue];
            NSString *frameName = [NSString stringWithFormat:@"%@%05d.png", animationFramePrefix,i];
            //[animationToReturn addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
            [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
        }
    }
    
    animationToReturn = [[[CCAnimation alloc] initWithFrames:frames delay:animationDelay] autorelease];
    return animationToReturn;
}

@end
