//
//  HUDLayer.m
//  TerminalVelocity
//
//  Created by Aaron Jones on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HUDLayer.h"

#import "GameManager.h"
#import "GameMusicManager.h"


@implementation HUDLayer
@synthesize numActionItems;

- (void)dealloc {
    [pauseButton release];
    [hudBatchNode release];
    [mphLabel release];
    [terminalLabel release];
    [scoreLabel release];
    [menuLayer release];
    [actionButton release];
    [super dealloc];
}

-(void)createHUD {
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    // top banner
    CCSprite *topBar = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"banner.png"]];
    [hudBatchNode addChild:topBar];
    [topBar setPosition:ccp(screenSize.width/2, screenSize.height-16)];
    
    // score font
    scoreLabel = [[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d", [GameManager sharedGameManager].score] fntFile:@"sky_scores.fnt"] retain];
    [self addChild:scoreLabel];
    [scoreLabel setAnchorPoint:ccp(0,0)];
    [scoreLabel setPosition:ccp(10, screenSize.height-16)];
    
    // terminal label
    terminalLabel = [[CCLabelBMFont labelWithString:@"050" fntFile:@"terminal_scores.fnt"] retain];
    [self addChild:terminalLabel];
    //terminalLabel.anchorPoint = ccp(0, 0);
    [terminalLabel setPosition:ccp((screenSize.width/2) - 18, screenSize.height-14)];
    
    mphLabel = [[CCLabelBMFont labelWithString:@"MPH" fntFile:@"terminal_scores.fnt"] retain];
    [self addChild:mphLabel];
    //mph.anchorPoint = ccp(0, 1);
    [mphLabel setPosition:ccp((screenSize.width/2) + 18, screenSize.height-14)];
    
    
    NSString *lvl;
    float dif = [GameManager sharedGameManager].difficultyLevel;
    if(dif <= kDifficultyHard)
        lvl = @"hard.png";
    else if(dif == kDifficultyMed)
        lvl = @"normal.png";
    else if(dif >= kDifficultyEasy)
        lvl = @"easy.png";

        
    CCSprite *difficultLvl = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:lvl]];
    [difficultLvl setPosition:ccp(screenSize.width/2+60, screenSize.height-11)];
    [self addChild:difficultLvl];
    
    //pause button
    //CCSprite *pauseButton = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"pause.png"]];
    pauseButton = [ButtonControl buttonWithSpriteFrameName:@"pause.png" downFrameName:nil target:self selectorStart:@selector(pauseButtonPressed:) selectorEnd:nil];
    [pauseButton setIsTouchEnabled:YES];
    [self addChild:pauseButton];
    [pauseButton setPosition:ccp(10, 45)];
    
}
                                  
-(void)pauseButtonPressed:(id)obj {
    
    
    if(![GameManager sharedGameManager].isInstructions )
    {
        if ([CCDirector sharedDirector].isPaused) {
               
            [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
            [self removeChild:menuLayer cleanup:YES];
            
            [actionButton setIsTouchEnabled:YES];
            [[CCDirector sharedDirector] resume];
            [GameManager sharedGameManager].isPaused = NO;
            
        } else {
            
            
            [[SimpleAudioEngine sharedEngine]pauseBackgroundMusic];
            [self showPausedMenu];
            
            [actionButton setIsTouchEnabled:NO];
            [[CCDirector sharedDirector] pause];
            [GameManager sharedGameManager].isPaused = YES;
        }
    }
    
}

-(void)showPausedMenu{

    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    menuLayer = [[[CCLayerColor alloc] initWithColor:ccc4(0, 0, 0, 128) width:screenSize.width height:screenSize.height] retain];
    
    [self addChild:menuLayer];
    
    // play button
    ButtonControl *playButton = [ButtonControl buttonWithSpriteFrameName:@"hud_placard.png" downFrameName:@"hud_placard_on.png" target:self selectorStart:@selector(pauseButtonPressed:)  selectorEnd:nil];
    
    [playButton setIsTouchEnabled:YES];
    playButton.position = ccp(screenSize.width * 0.3f, screenSize.height * 0.7f);
    [menuLayer addChild:playButton];
    
    CGSize box = playButton.boundingBox.size;
    CCLabelBMFont *playLabel = [CCLabelBMFont labelWithString:@"Play" fntFile:@"menus.fnt"];
    playLabel.position = [playButton convertToWorldSpace:ccp(box.width *0.5f, box.height*0.5f)];
    [menuLayer addChild:playLabel];
    
    // mainMenu button
    ButtonControl *mainMenuButton = [ButtonControl buttonWithSpriteFrameName:@"hud_placard.png" downFrameName:@"hud_placard_on.png" target:self 
                                                              selectorStart:@selector(mainMenuButtonPressed:) selectorEnd:nil];
    [mainMenuButton setIsTouchEnabled:YES];
    mainMenuButton.position = ccp(screenSize.width * 0.3f, screenSize.height * 0.6f);
    [menuLayer addChild:mainMenuButton];
    
    box = mainMenuButton.boundingBox.size;
    CCLabelBMFont *mainMenuLabel = [CCLabelBMFont labelWithString:@"Main Menu" fntFile:@"menus.fnt"];
    mainMenuLabel.position = [mainMenuButton convertToWorldSpace:ccp(box.width *0.5f, box.height*0.5f)];
    [menuLayer addChild:mainMenuLabel];
     
    
    
    
}

-(void)mainMenuButtonPressed:(id)sender{
    
    
    GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
    
    float dif = [GameManager sharedGameManager].difficultyLevel;
    if(dif <= kDifficultyHard)
        [gkHelper submitScore:[GameManager sharedGameManager].score category:@"hardHighestScore"];
    else if(dif == kDifficultyMed)
        [gkHelper submitScore:[GameManager sharedGameManager].score category:@"medHighestScore"];
    else if(dif >= kDifficultyEasy)
        [gkHelper submitScore:[GameManager sharedGameManager].score category:@"easyHighestScore"];

    
    [[CCDirector sharedDirector] resume];
    [[GameManager sharedGameManager] setIsPaused:NO]; 
    [[GameManager sharedGameManager] runSceneWithID:kMainMenuScene];
}

-(id)init {
    self = [super init];
    if (self != nil) {
        isActionButtonPressed = NO;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"hud_items.plist"];
            hudBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"hud_items.png"];
        } else {
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"hud_items.plist"];
            hudBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"hud_items.png"];
        }
        [hudBatchNode retain];
        [self addChild:hudBatchNode];
        [self createHUD];
        
        // temp
        //CCLayerColor *layer = [CCLayerColor layerWithColor:ccc4(0, 0, 255, 255)];
        //[self addChild:layer z:0 tag:0];
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        zeroHeight = screenSize.height - 100.0f;
    
        
    }
    return self;
    
}

-(void)hideHUD {
    terminalLabel.visible = NO;
    scoreLabel.visible = NO;
    hudBatchNode.visible = NO;
    mphLabel.visible = NO;
}

static int loop = 0;
-(void)updateHUD:(ccTime)deltaTime pos:(CGPoint)pos {
    if ([GameManager sharedGameManager].hasPlayerDied) {
        [self hideHUD];
        return;
    }
    
    //[terminalLabel setString:[NSString stringWithFormat:@"%03d", (int) (10*backLayer.velocity)]];
    //CGSize screenSize = [CCDirector sharedDirector].winSize;
    static float vel = 10.0f;
    
    float yPos = pos.y;
    if (yPos < zeroHeight && yPos > 0) {
        vel = 2000.0f / yPos;
    
        [terminalLabel setString:[NSString stringWithFormat:@"%03d", (int) (10*vel)]];
    }else {
        // -1 or 1
        ++loop;
        if (loop % 10 == 0) {
            loop = 0;
            int sign = arc4random() % 2 ? 1 : -1;
            [terminalLabel setString:[NSString stringWithFormat:@"%03d", 50 + sign]];
        } 
         
    }
       

    
    [scoreLabel setString:[NSString stringWithFormat:@"%d", [GameManager sharedGameManager].score]];
}

-(void)registerGameObjectTarget:(GameObject *)target action:(GameActionControl)action selector:(SEL)selector {
    switch (action) {
        case kActionControlButton: {
            actionButton.targetNode = target;
            actionButton.selStart = selector;
            break;
        }
        default:
            break;
    }
    
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    return TRUE;
}

@end
