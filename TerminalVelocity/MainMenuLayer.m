//
//  MainMenuLayer.m
//  TerminalVelocity
//
//  Created by Aaron Jones on 7/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenuLayer.h"
#import "GameManager.h"
#import "LoadingScene.h"
#import "GameMusicManager.h"
#import "AppDelegate.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

float buttonspace = -.06;

@implementation MainMenuLayer

- (void)dealloc {
    [mainMenuLayer release];
    [difficultyLayer release];
    [optionsMenuLayer release];
    [statsLayer release];
    [objectiveLayer release];
    [super dealloc];
}

-(void)addAlienAnim {
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    CCSprite *alien = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alienmenu00001.png"]];
    [alien setPosition:ccp(45, screenSize.height - 50)];
    [self addChild:alien];
    
    CCAnimation *anim = [CCAnimation animation];
    [anim setDelay:1.0f];
    
    for (int i = 1; i <= 4 ; i++) {
        NSString *frameName = [NSString stringWithFormat:@"%@%05d.png",@"alienmenu",i];
        [anim addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
    }
    
    id animateAction = [CCAnimate actionWithAnimation:anim];
    id repeatAction = [CCRepeatForever actionWithAction:animateAction];
    
    [alien runAction:repeatAction];
    
    CCMoveBy *m1 = [CCMoveTo actionWithDuration:0.5 position:ccp(alien.position.x + 6,alien.position.y + 5)];
    CCMoveBy *m2 = [CCMoveTo actionWithDuration:0.5 position:ccp(alien.position.x + 5,alien.position.y - 5)];
    CCMoveBy *m3 = [CCMoveTo actionWithDuration:0.5 position:ccp(alien.position.x - 5,alien.position.y - 5)];
    CCMoveBy *m4 = [CCMoveTo actionWithDuration:0.5 position:ccp(alien.position.x - 7,alien.position.y + 7)];
    CCMoveBy *m5 = [CCMoveTo actionWithDuration:0.5 position:ccp(alien.position.x - 5,alien.position.y - 5)];
    CCMoveBy *m6 = [CCMoveTo actionWithDuration:0.5 position:ccp(alien.position.x,alien.position.y)];
    
    id repeatMove = [CCRepeatForever actionWithAction:[CCSequence actions:m1,m2,m3,m4,m5, m6,nil]];
    [alien runAction:repeatMove];
}

-(void)hidePreviousTextBlocks{
    [self removeChild:broward cleanup:YES];
    [self removeChild:objectiveLabel cleanup:YES];
}
-(void)hideMainMenuButtons{
    [self removeChild:mainMenuLayer cleanup:YES];
}

-(void)hideOptionsMenuButtons:(BOOL)willAnimate{
    
    if(willAnimate)
    {
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        id  slideOut=[CCMoveBy actionWithDuration:0.1f position:ccp(screenSize.width+20, 0)];
        [optionsMenuLayer runAction:slideOut];
           
        
        id removeChild = [CCCallBlockN actionWithBlock:^(CCNode *node) {
         [self removeChild:optionsMenuLayer cleanup:YES];
        }];
        
        [optionsMenuLayer runAction:[CCSequence actions: slideOut, removeChild, nil]];
    }
    else
        [self removeChild:optionsMenuLayer cleanup:YES];
    
}

-(void)addBrowardAnim {
    
    [self removeChild:broward cleanup:YES];
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    broward = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"jetpackmenu00000.png"]];
    [broward setPosition:ccp(screenSize.width * 0.3f, screenSize.height * 0.55f)];
    [self addChild:broward];
    
    CCAnimation *anim1 = [CCAnimation animation];
    
    [anim1 setDelay:0.04f];
    
    for (int i = 0; i <= 12 ; i++) {
        NSString *frameName = [NSString stringWithFormat:@"%@%05d.png",@"jetpackmenu",i];
        [anim1 addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
    }
    
    id animateAction1 = [CCAnimate actionWithAnimation:anim1 restoreOriginalFrame:NO];
    
    
    
    CCAnimation *anim2 = [CCAnimation animation];
    
    [anim2 setDelay:0.04f];
    
    for (int i = 13; i <= 48 ; i++) {
        NSString *frameName = [NSString stringWithFormat:@"%@%05d.png",@"jetpackmenu",i];
        [anim2 addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
    }
    
    id animateAction2 = [CCAnimate actionWithAnimation:anim2];
    id repeatAction2 = [CCRepeatForever actionWithAction:animateAction2];
    
    
    CCMoveBy *m1 = [CCMoveTo actionWithDuration:0.5 position:ccp(broward.position.x +5,broward.position.y + 6)];
    CCMoveBy *m2 = [CCMoveTo actionWithDuration:0.5 position:ccp(broward.position.x -3,broward.position.y + 4)];
    CCMoveBy *m3 = [CCMoveTo actionWithDuration:0.5 position:ccp(broward.position.x + 7,broward.position.y - 8)];
    CCMoveBy *m4 = [CCMoveTo actionWithDuration:0.5 position:ccp(broward.position.x,broward.position.y)];
    
    id repeatMove = [CCRepeatForever actionWithAction:[CCSequence actions:m1,m2,m3,m4,nil]];
    
    CCCallBlockN *blockAction = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        //[node stopAllActions];
        [node runAction:repeatAction2];
        [node runAction:repeatMove];
         }];

    [broward runAction:[CCSequence actions:animateAction1,blockAction, nil]];
    
}

-(void)displayOptionsMenu:(BOOL)willAnimiate{
    
     CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    optionsMenuLayer = [[CCLayer alloc] init];
    //[self addChild:optionsMenuLayer];
       
    
    // flip screen button
    ButtonControl *flipScreenButton = [ButtonControl buttonWithSpriteFrameName:@"placard.png" downFrameName:@"placard_on.png" target:self selectorStart:nil  selectorEnd:@selector(difficultyButtonPressed:)];
    
    [flipScreenButton setIsTouchEnabled:YES];
    flipScreenButton.position = ccp(screenSize.width * 0.54f, screenSize.height * 0.6f);
    [optionsMenuLayer addChild:flipScreenButton];
    
    CGSize box = flipScreenButton.boundingBox.size;
    CCLabelBMFont *flipLabel = [CCLabelBMFont labelWithString:@"Difficulty" fntFile:@"menus.fnt"];
    flipLabel.position = [flipScreenButton convertToWorldSpace:ccp(box.width *0.5f, box.height*0.5f)];
    [optionsMenuLayer addChild:flipLabel];
    
    //sound volumn
    volumnButton = [ButtonControl buttonWithSpriteFrameName:@"placard.png" downFrameName:@"placard_on.png" target:self selectorStart:nil  selectorEnd:@selector(volumnButtonPressed:)];
    
    [volumnButton setIsTouchEnabled:YES];
    volumnButton.position = ccp(screenSize.width * 0.54f, screenSize.height * 0.5f);
    [optionsMenuLayer addChild:volumnButton];
    
    box = volumnButton.boundingBox.size;
    volumnLabel = [CCLabelBMFont labelWithString:@"Mute" fntFile:@"menus.fnt"];
    volumnLabel.position = [volumnButton convertToWorldSpace:ccp(box.width *0.5f, box.height*0.5f)];
    [optionsMenuLayer addChild:volumnLabel];
    
    //instructions button
    ButtonControl *instructionsButton = [ButtonControl buttonWithSpriteFrameName:@"placard.png" downFrameName:@"placard_on.png" target:self selectorStart:nil  selectorEnd:@selector(instructionsButtonPressed:)];
    
    [instructionsButton setIsTouchEnabled:YES];
    instructionsButton.position = ccp(screenSize.width * 0.54f, screenSize.height * 0.4f);
    [optionsMenuLayer addChild:instructionsButton];
    
    box = instructionsButton.boundingBox.size;
    CCLabelBMFont *instructionsLabel = [CCLabelBMFont labelWithString:@"Instructions" fntFile:@"menus.fnt"];
    instructionsLabel.position = [instructionsButton convertToWorldSpace:ccp(box.width *0.5f, box.height*0.5f)];
    [optionsMenuLayer addChild:instructionsLabel];
    
    
    ButtonControl *faceBookLoginButton;
    CCLabelBMFont *facebookLabel;
    NSString *buttonString;
    
    // Check and retrieve authorization information
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        [delegate facebook].accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        [delegate facebook].expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
        
        // facebook button
        faceBookLoginButton = [ButtonControl buttonWithSpriteFrameName:@"placard_facebook.png" downFrameName:@"placard_facebook_on.png" target:self selectorStart:nil selectorEnd:@selector(logOutFaceBookPressed:)];
        buttonString=@"Log Out";
       
    }
    if (![[delegate facebook] isSessionValid]) {
        
        // facebook button
        faceBookLoginButton = [ButtonControl buttonWithSpriteFrameName:@"placard_facebook.png" downFrameName:@"placard_facebook_on.png" target:self selectorStart:nil selectorEnd:@selector(loginFaceBookPressed:)];
        buttonString=@"Login";
        
        
    }
    
    [faceBookLoginButton setIsTouchEnabled:YES];
    faceBookLoginButton.position = ccp(screenSize.width * 0.54f, screenSize.height * 0.3f);
    [optionsMenuLayer addChild:faceBookLoginButton];
    
    box = faceBookLoginButton.boundingBox.size;
    facebookLabel = [CCLabelBMFont labelWithString:buttonString fntFile:@"menus.fnt"];
    facebookLabel.position = [faceBookLoginButton convertToWorldSpace:ccp(box.width *0.5f, box.height*0.5f)];
    [optionsMenuLayer addChild:facebookLabel];
    
    //back button
    ButtonControl *backButton = [ButtonControl buttonWithSpriteFrameName:@"placard.png" downFrameName:@"placard_on.png" target:self selectorStart:nil  selectorEnd:@selector(backButtonPressed:)];
    
    [backButton setIsTouchEnabled:YES];
    backButton.position = ccp(screenSize.width * 0.54f, screenSize.height * 0.2f);
    [optionsMenuLayer addChild:backButton];
    
    box = backButton.boundingBox.size;
    CCLabelBMFont *backLabel = [CCLabelBMFont labelWithString:@"Back" fntFile:@"menus.fnt"];
    backLabel.position = [backButton convertToWorldSpace:ccp(box.width *0.5f, box.height*0.5f)];
    [optionsMenuLayer addChild:backLabel];
    
    if(willAnimiate)
    {
        [optionsMenuLayer setPosition:ccp(120,0)];
        
        id addChild = [CCCallBlockN actionWithBlock:^(CCNode *node) {
            [self addChild:optionsMenuLayer];
            id  slideIn=[CCMoveBy actionWithDuration:0.1f position:ccp(-120, 0)];
            [optionsMenuLayer runAction:slideIn];
        }];
        
        [optionsMenuLayer runAction:[CCSequence actions: addChild, nil]];
    }
    else
       [self addChild:optionsMenuLayer]; 

}

-(void)displayMainMenu {
 
    mainMenuLayer = [[CCLayer alloc] init];
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    // play button
    ButtonControl *playButton = [ButtonControl buttonWithSpriteFrameName:@"placard.png" downFrameName:@"placard_on.png" target:self selectorStart:nil  selectorEnd:@selector(playButtonPressed:)];
    
    [playButton setIsTouchEnabled:YES];
    playButton.position = ccp(screenSize.width * 0.54f, screenSize.height * 0.6f);
    [mainMenuLayer addChild:playButton];
    
    CGSize box = playButton.boundingBox.size;
    CCLabelBMFont *playLabel = [CCLabelBMFont labelWithString:@"Play" fntFile:@"menus.fnt"];
    playLabel.position = [playButton convertToWorldSpace:ccp(box.width *0.5f, box.height*0.5f)];
    [mainMenuLayer addChild:playLabel];
    
    
    // options button
    ButtonControl *optionsButton = [ButtonControl buttonWithSpriteFrameName:@"placard.png" downFrameName:@"placard_on.png" target:self 
                                                             selectorStart:nil selectorEnd:@selector(optionsButtonPressed:)];
    [optionsButton setIsTouchEnabled:YES];
    optionsButton.position = ccp(screenSize.width * 0.54f, screenSize.height * 0.5f);
    [mainMenuLayer addChild:optionsButton];
    
    box = optionsButton.boundingBox.size;
    CCLabelBMFont *optionsLabel = [CCLabelBMFont labelWithString:@"Options" fntFile:@"menus.fnt"];
    optionsLabel.position = [optionsButton convertToWorldSpace:ccp(box.width *0.5f, box.height*0.5f)];
    [mainMenuLayer addChild:optionsLabel];
    
    // objective button
    ButtonControl *objectiveButton = [ButtonControl buttonWithSpriteFrameName:@"placard.png" downFrameName:@"placard_on.png" target:self 
                                                                selectorStart:nil selectorEnd:@selector(objectiveButtonPressed:)];
    [objectiveButton setIsTouchEnabled:YES];
    objectiveButton.position = ccp(screenSize.width * 0.54f, screenSize.height * 0.4f);
    [mainMenuLayer addChild:objectiveButton];
    
    box = objectiveButton.boundingBox.size;
    CCLabelBMFont *objectiveButtonLabel = [CCLabelBMFont labelWithString:@"Objective" fntFile:@"menus.fnt"];
    objectiveButtonLabel.position = [objectiveButton convertToWorldSpace:ccp(box.width *0.5f, box.height*0.5f)];
    [mainMenuLayer addChild:objectiveButtonLabel];
    
    // stats button
    statsButton = [ButtonControl buttonWithSpriteFrameName:@"placard.png" downFrameName:@"placard_on.png" target:self 
                                                                selectorStart:nil selectorEnd:@selector(statsButtonPressed:)];
    [statsButton setIsTouchEnabled:YES];
    statsButton.position = ccp(screenSize.width * 0.54f, screenSize.height * 0.3f);
    
    
    box = statsButton.boundingBox.size;
    CCLabelBMFont *statsLabel = [CCLabelBMFont labelWithString:@"Stats" fntFile:@"menus.fnt"];
    statsLabel.position = ccp(box.width*.5,box.height*.5); 
    [statsButton addChild:statsLabel];
    //GAME CENTER IS ONLY AVAILABLE FOR 4.1 AND HIGHER OS SO DONT SHOW BUTTONS IF LESS
    GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"4.1") && localPlayer.authenticated == YES)
        [mainMenuLayer addChild:statsButton];
    
    [mainMenuLayer setPosition:ccp(120,0)];
    
    id addChild = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [self addChild:mainMenuLayer];
        id  slideIn=[CCMoveBy actionWithDuration:0.1f position:ccp(-120, 0)];
        [mainMenuLayer runAction:slideIn];
    }];
    
    [mainMenuLayer runAction:[CCSequence actions: addChild, nil]];
    
    [self addBrowardAnim];

}

-(void)setUpOptions{
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    CCSprite *thankYouPanel = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"objective_bg.png"]];
    [thankYouPanel setPosition:ccp(screenSize.width / 3.7, screenSize.height / 2.28)];
    
    CCLabelBMFont *creditsLabel = [CCLabelBMFont labelWithString:@"Thanks to:\n\nwww.Box2D.org\n{ for the physics engine\n\nwww.cocos2d-iphone.org\n{ for game framework\n\nValentin Antonov\nval@divastudio.net\n{ for the font obelix pro\n\nSpecial Thanks to:\n{ Mason, Hudson, Buddy,\nShadowman, Broward\nfor lending his name, \nMadison's mom Heather,\nfor cleaning up the \nobjective text. Trig for \nhis contribution, and \nAll the beta testers." fntFile:@"recognition.fnt"];
    
    creditsLabel.position = CGPointMake(screenSize.width / 3.65, screenSize.height / 2.18);
    
    [optionsMenuLayer addChild:thankYouPanel];
    [optionsMenuLayer addChild:creditsLabel];
}

-(void)addGameCenterButtons{

    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    //leaderboard button
    ButtonControl *achievementsButton = [ButtonControl buttonWithSpriteFrameName:@"placard.png" downFrameName:@"placard_on.png" target:self selectorStart:nil  selectorEnd:@selector(achievementButtonPressed:)];
    CGSize box = achievementsButton.boundingBox.size;
    [achievementsButton setIsTouchEnabled:YES];
    achievementsButton.position = ccp(screenSize.width * 0.04f, screenSize.height * (0.15f+buttonspace));
    [statsLayer addChild:achievementsButton];
    
    box = achievementsButton.boundingBox.size;
    CCLabelBMFont *achievementsLabel = [CCLabelBMFont labelWithString:@"Achievements" fntFile:@"menus.fnt"];
    achievementsLabel.position = [achievementsButton convertToWorldSpace:ccp(box.width *0.5f, box.height*0.5f)];
    [statsLayer addChild:achievementsLabel];
    
    //leadersboard button
    ButtonControl *leadersBoardButton = [ButtonControl buttonWithSpriteFrameName:@"placard.png" downFrameName:@"placard_on.png" target:self selectorStart:nil  selectorEnd:@selector(leadersBoardButtonPressed:)];
    
    [leadersBoardButton setIsTouchEnabled:YES];
    leadersBoardButton.position = ccp(screenSize.width * 0.52f, screenSize.height * (0.15f+buttonspace));
    [statsLayer addChild:leadersBoardButton];
    
    box = leadersBoardButton.boundingBox.size;
    CCLabelBMFont *leadersBoardLabel = [CCLabelBMFont labelWithString:@"Leaderboard" fntFile:@"menus.fnt"];
    leadersBoardLabel.position = [leadersBoardButton convertToWorldSpace:ccp(box.width *0.5f, box.height*0.5f)];
    [statsLayer addChild:leadersBoardLabel];

    
    /** TESTING BUTTON **/
    #if COCOS2D_DEBUG
        //reset leadersboard button
        ButtonControl *resetLeadersBoardButton = [ButtonControl buttonWithSpriteFrameName:@"placard.png" downFrameName:@"placard_on.png" target:self selectorStart:nil  selectorEnd:@selector(restLeadersBoardButtonPressed:)];
        
        [resetLeadersBoardButton setIsTouchEnabled:YES];
        resetLeadersBoardButton.position = ccp(screenSize.width * 0.52f, screenSize.height * (0.06f+buttonspace));
        [statsLayer addChild:resetLeadersBoardButton];
        
        box = resetLeadersBoardButton.boundingBox.size;
        CCLabelBMFont *resetLeadersBoardLabel = [CCLabelBMFont labelWithString:@"Rest LB" fntFile:@"menus.fnt"];
        resetLeadersBoardLabel.position = [resetLeadersBoardButton convertToWorldSpace:ccp(box.width *0.5f, box.height*0.5f)];
        [statsLayer addChild:resetLeadersBoardLabel];
    
        //reset user data
        ButtonControl *resetUserDataButton = [ButtonControl buttonWithSpriteFrameName:@"placard.png" downFrameName:@"placard_on.png" target:self selectorStart:nil  selectorEnd:@selector(restUserDataButtonPressed:)];
        
        [resetUserDataButton setIsTouchEnabled:YES];
        resetUserDataButton.position = ccp(screenSize.width * 0.04f, screenSize.height * (0.06f+buttonspace));
        [statsLayer addChild:resetUserDataButton];
        
        box = resetUserDataButton.boundingBox.size;
        CCLabelBMFont *resetUserDataLabel = [CCLabelBMFont labelWithString:@"Rest Data" fntFile:@"menus.fnt"];
        resetUserDataLabel.position = [resetUserDataButton convertToWorldSpace:ccp(box.width *0.5f, box.height*0.5f)];
        [statsLayer addChild:resetUserDataLabel];
    
        
    #endif
}

#pragma mark -
#pragma mark FACEBOOK SHIT
// Pre 4.2 support
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [[delegate facebook] handleOpenURL:url]; 
}

// For 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[delegate facebook] handleOpenURL:url]; 
}

- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[[delegate facebook] accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[[delegate facebook] expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    //return to main menu
    [self hidePreviousTextBlocks];
    [self removeChild:difficultyLayer cleanup:YES ];
    [self hideOptionsMenuButtons:NO];
    [self removeChild:statsLayer cleanup:YES];
    [self displayMainMenu];
    [tableView removeFromSuperview];
    
}
- (void) fbDidLogout {
    // Remove saved authorization information if it exists
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
        
        [self hidePreviousTextBlocks];
        [self removeChild:difficultyLayer cleanup:YES ];
        [self hideOptionsMenuButtons:NO];
        [self removeChild:statsLayer cleanup:YES];
        
        //hide the main manu buttons
        [self hideMainMenuButtons];
        [self hidePreviousTextBlocks];        
        //add other option menu items
        [self displayOptionsMenu:YES];        
        [self setUpOptions];
    }
}

#pragma mark -
#pragma mark Load Stats
-(void)loadEasyNames:(id)sender{ 

    [easyTab setIsTouchEnabled: NO];
    [normalTab setIsTouchEnabled:NO];
    [hardTab setIsTouchEnabled:NO];
    [self addtabs:kEasy];
    [tableView removeFromSuperview];
    [[GameKitHelper sharedGameKitHelper]retrieveTopFiftyAllTimeGlobalScores:@"easyHighestScore"];
    
}

-(void)loadNormalNames:(id)sender{

    [easyTab setIsTouchEnabled: NO];
    [normalTab setIsTouchEnabled:NO];
    [hardTab setIsTouchEnabled:NO];
    [self addtabs:kNormal];
    [tableView removeFromSuperview];
    [[GameKitHelper sharedGameKitHelper]retrieveTopFiftyAllTimeGlobalScores:@"medHighestScore"];
}
-(void)loadHardNames:(id)sender{

    [easyTab setIsTouchEnabled: NO];
    [normalTab setIsTouchEnabled:NO];
    [hardTab setIsTouchEnabled:NO];
    [self addtabs:kHard];
    [tableView removeFromSuperview];
    [[GameKitHelper sharedGameKitHelper]retrieveTopFiftyAllTimeGlobalScores:@"hardHighestScore"];

}


-(void)addtabs:(int)currentTab{
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    //remove them first
    [statsLayer removeChild:easyTab cleanup:YES];
    [statsLayer removeChild:normalTab cleanup:YES];
    [statsLayer removeChild:hardTab cleanup:YES];
    
    NSString *easyOn = @"stats_tab.png";
    NSString *normalOn = @"stats_tab.png";
    NSString *hardOn = @"stats_tab.png"; // ahh huh huh, you said hard, on huh huh .. shut up butthead!
    
    switch (currentTab) {
        case kEasy:
            easyOn = @"stats_tab_on.png";
            break;
        case kNormal:
            normalOn = @"stats_tab_on.png";
            break;
        case kHard:
            hardOn = @"stats_tab_on.png";
            break;
    }
    
    //easy button
    easyTab = [ButtonControl buttonWithSpriteFrameName:easyOn downFrameName:@"stats_tab_on.png" target:self selectorStart:nil  selectorEnd:@selector(loadEasyNames:)];
    easyTab.position = ccp(screenSize.width *.1, screenSize.height *.525);
    //[easyTab setIsTouchEnabled:YES];
    [statsLayer addChild:easyTab];
    
    CGSize tabbox = easyTab.boundingBox.size;
    CCLabelBMFont *easyLabel = [CCLabelBMFont labelWithString:@"Easy" fntFile:@"menus.fnt"];
    easyLabel.position = [easyTab convertToWorldSpace:ccp(tabbox.width *0.5f, tabbox.height*0.35f)];
    [statsLayer addChild:easyLabel];
    
    //normal button
    normalTab = [ButtonControl buttonWithSpriteFrameName:normalOn downFrameName:@"stats_tab_on.png" target:self selectorStart:nil  selectorEnd:@selector(loadNormalNames:)];
   // [normalTab setIsTouchEnabled:YES];
    normalTab.position = ccp(screenSize.width *.378, screenSize.height *.525);
    [statsLayer addChild:normalTab];
    
    tabbox = normalTab.boundingBox.size;
    CCLabelBMFont *normalLabel = [CCLabelBMFont labelWithString:@"Norm" fntFile:@"menus.fnt"];
    normalLabel.position = [normalTab convertToWorldSpace:ccp(tabbox.width *0.5f, tabbox.height*0.35f)];
    [statsLayer addChild:normalLabel];
    
    //hard button
    hardTab = [ButtonControl buttonWithSpriteFrameName:hardOn downFrameName:@"stats_tab_on.png" target:self selectorStart:nil  selectorEnd:@selector(loadHardNames:)];
    //[hardTab setIsTouchEnabled:YES];
    hardTab.position = ccp(screenSize.width *.655, screenSize.height *.525);
    [statsLayer addChild:hardTab];
    
    tabbox = hardTab.boundingBox.size;
    CCLabelBMFont *hardLabel = [CCLabelBMFont labelWithString:@"Hard" fntFile:@"menus.fnt"];
    hardLabel.position = [hardTab convertToWorldSpace:ccp(tabbox.width *0.5f, tabbox.height*0.35f)];
    [statsLayer addChild:hardLabel];
    
}
#pragma mark -
#pragma mark ButtonPress Methods
-(void)restUserDataButtonPressed:(id)sender{
       
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"notANoob"];   
    
    NSDictionary *defaultsDictionary = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    for (NSString *key in [defaultsDictionary allKeys]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    //NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
   // NSString *myString = [prefs stringForKey:@"SatAchievment"];
    //CCLOG(@"USER DATA: %@",myString);

}
-(void)restLeadersBoardButtonPressed:(id)sender{
    [[GameKitHelper sharedGameKitHelper] resetAchievements];
}
-(void) logOutFaceBookPressed:(id)sender{
    [[delegate facebook] logout:self];
}

-(void)loginFaceBookPressed:(id)sender {
    
    // Check and retrieve authorization information
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        [delegate facebook].accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        [delegate facebook].expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    if (![[delegate facebook] isSessionValid]) {
        [delegate facebook].sessionDelegate = self;
        NSArray *permissions = [[NSArray alloc] initWithObjects:@"user_likes",@"read_stream",nil];
        [[delegate facebook] authorize:permissions];
        [permissions release];
    }
}
-(void)statsButtonPressed:(id)sender {

    //GAME CENTER IS ONLY AVAILABLE FOR 4.1 AND HIGHER OS SO DONT SHOW BUTTONS IF LESS
    GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"4.1") && localPlayer.authenticated == YES)
    {
        [self hideMainMenuButtons];
        //hide broward animation
        [self removeChild:broward cleanup:YES];
        
        statsLayer = [[CCLayer alloc] init];
        
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        CCSprite *objectivePanel = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"stats_bg.png"]];
        [objectivePanel setPosition:ccp(screenSize.width / 2, screenSize.height / (2.75))];
      
        [statsLayer addChild:objectivePanel];
        
        [self addtabs:kNormal];
        
        //back button
        ButtonControl *backButton = [ButtonControl buttonWithSpriteFrameName:@"placard.png" downFrameName:@"placard_on.png" target:self selectorStart:nil  selectorEnd:@selector(backButtonPressed:)];
        
        [backButton setIsTouchEnabled:YES];
        backButton.position = ccp(screenSize.width * 0.3f, screenSize.height * 0.6f);
        [statsLayer addChild:backButton];
        
        CGSize box = backButton.boundingBox.size;
        CCLabelBMFont *backLabel = [CCLabelBMFont labelWithString:@"Back" fntFile:@"menus.fnt"];
        backLabel.position = [backButton convertToWorldSpace:ccp(box.width *0.5f, box.height*0.5f)];
        [statsLayer addChild:backLabel];
        
        [self addGameCenterButtons];     
        
        [statsLayer setPosition:ccp(120,0)];
        
        id addChild = [CCCallBlockN actionWithBlock:^(CCNode *node) {
            [self addChild:statsLayer];
            id  slideIn=[CCMoveBy actionWithDuration:0.1f position:ccp(-120, 0)];
            [statsLayer runAction:slideIn];
            [[GameKitHelper sharedGameKitHelper]retrieveTopFiftyAllTimeGlobalScores:@"medHighestScore"];
        }];
        
        [statsLayer runAction:[CCSequence actions: addChild, nil]];
    }
    //[self addChild:statsLayer];
     
    
}

-(void)volumnButtonPressed:(id)sender{

    CGSize screenSize = [CCDirector sharedDirector].winSize;
    [optionsMenuLayer removeChild:volumnButton cleanup:YES];
    
    
    volumnButton = [ButtonControl buttonWithSpriteFrameName:@"placard.png" downFrameName:@"placard_on.png" target:self selectorStart:nil  selectorEnd:@selector(volumnButtonPressed:)];
    
    [volumnButton setIsTouchEnabled:YES];
    volumnButton.position = ccp(screenSize.width * 0.54f, screenSize.height * 0.5f);
    [optionsMenuLayer addChild:volumnButton];
    CGSize box = volumnButton.boundingBox.size;
    
    if([[CDAudioManager sharedManager] mute])
    {
        volumnLabel = [CCLabelBMFont labelWithString:@"Mute" fntFile:@"menus.fnt"];
        [CDAudioManager sharedManager].mute = FALSE;
    }
    else
    {
        volumnLabel = [CCLabelBMFont labelWithString:@"UnMute" fntFile:@"menus.fnt"];
        [CDAudioManager sharedManager].mute = TRUE;
    }
    volumnLabel.position = [volumnButton convertToWorldSpace:ccp(box.width *0.5f, box.height*0.5f)];
    [optionsMenuLayer addChild:volumnLabel];
        
}

-(void)instructionsButtonPressed:(id)sender{

    [self hideOptionsMenuButtons:NO];
    
    //hide the main manu buttons
    [self hideMainMenuButtons];
    
    [self hidePreviousTextBlocks];
    
    
    //add other option menu items
    [self displayOptionsMenu:NO];
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    CCSprite *instructions = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"instructions_bg.png"]];
    [instructions setPosition:ccp(screenSize.width / 3.7, screenSize.height / 2.35)];
    
    CCLabelBMFont *parachutteText = [CCLabelBMFont labelWithString:@"deploys \ntemporary \nparachute to \nbreifly slow \nyour speed" fntFile:@"recognition.fnt"];
    parachutteText.position = CGPointMake(screenSize.width / 3.5, screenSize.height / 2.45);
    
    CCLabelBMFont *rocketText = [CCLabelBMFont labelWithString:@"deploys \ntemporary \nrocket to \nbreifly slow \nyour speed" fntFile:@"recognition.fnt"];
    rocketText.position = CGPointMake(screenSize.width / 3.5, screenSize.height / 3.45);
    
    //CCLabelBMFont *avoidText = [CCLabelBMFont labelWithString:@"avoid \nitems that \nglow red!" fntFile:@"recognition.fnt"];
    //avoidText.position = CGPointMake(screenSize.width / 3.7, screenSize.height / 5.3);
    
    
    CCSprite *instructions2 = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"instructions2.png"]];
    [instructions2 setPosition:ccp(screenSize.width / 7.2, screenSize.height / 1.75)];
    
    CCSprite *instructions1 = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"instructions1.png"]];
    [instructions1 setPosition:ccp(screenSize.width / 2.5, screenSize.height / 1.75)];

    
    //icons
    CCSprite *parachute = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"chute.png"]];
    parachute.position = CGPointMake(screenSize.width / 8.5, screenSize.height / 2.27);
   
    CCSprite *rocket = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rocket.png"]];
    rocket.position = CGPointMake(screenSize.width /8.5, screenSize.height / 3.20);
    
   // CCSprite *avoid = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"avoid.png"]];
    //avoid.position = CGPointMake(screenSize.width /8.5, screenSize.height / 5.2);
    
    
    [optionsMenuLayer addChild:instructions];
    [optionsMenuLayer addChild:parachutteText];
    //[optionsMenuLayer addChild:avoidText];
    [optionsMenuLayer addChild:rocketText];
    [optionsMenuLayer addChild:parachute];
    [optionsMenuLayer addChild:rocket]; 
    //[optionsMenuLayer addChild:avoid];
    [optionsMenuLayer addChild:instructions1];
    [optionsMenuLayer addChild:instructions2];
    
    
    
}

-(void)backButtonPressedToOptions:(id)sender{


    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    id  slideOut=[CCMoveBy actionWithDuration:0.1f position:ccp(screenSize.width+20, 0)];
    [difficultyLayer runAction:slideOut];
    
    
    id removeChild = [CCCallBlockN actionWithBlock:^(CCNode *node) {
            [self removeChild:difficultyLayer cleanup:YES ];
    }];
    
    [difficultyLayer runAction:[CCSequence actions: slideOut, removeChild, nil]];
    
    //hide the main manu buttons
    [self hideMainMenuButtons];
    
    [self hidePreviousTextBlocks];
    
    //add other option menu items
    [self displayOptionsMenu:YES];
    
    [self setUpOptions];
}

-(void)backButtonPressed:(id)sender{
    [self hidePreviousTextBlocks];
    [self removeChild:difficultyLayer cleanup:YES ];
    [self hideOptionsMenuButtons:NO];
    [self removeChild:statsLayer cleanup:YES];
    [self displayMainMenu];
    [tableView removeFromSuperview];
}

-(void)difficultyButtonPressed:(id)sender{

    [self hideOptionsMenuButtons:YES];
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    difficultyLayer = [[CCLayer alloc] init];
    
    //*************************/
    // flip screen button
    ButtonControl *easyButton = [ButtonControl buttonWithSpriteFrameName:@"placard.png" downFrameName:@"placard_on.png" target:self selectorStart:nil  selectorEnd:@selector(easyButtonPressed:)];
    
    [easyButton setIsTouchEnabled:YES];
    easyButton.position = ccp(screenSize.width * 0.54f, screenSize.height * 0.6f);
    [difficultyLayer addChild:easyButton];
    
    CGSize box = easyButton.boundingBox.size;
    CCLabelBMFont *easyLabel = [CCLabelBMFont labelWithString:@"Easy" fntFile:@"menus.fnt"];
    easyLabel.position = [easyButton convertToWorldSpace:ccp(box.width *0.5f, box.height*0.5f)];
    [difficultyLayer addChild:easyLabel];
    
    //sound volumn
    ButtonControl *mediumButton = [ButtonControl buttonWithSpriteFrameName:@"placard.png" downFrameName:@"placard_on.png" target:self selectorStart:nil  selectorEnd:@selector(mediumButtonPressed:)];
    
    [mediumButton setIsTouchEnabled:YES];
    mediumButton.position = ccp(screenSize.width * 0.54f, screenSize.height * 0.5f);
    [difficultyLayer addChild:mediumButton];
    
    box = mediumButton.boundingBox.size;
    CCLabelBMFont *mediumLabel = [CCLabelBMFont labelWithString:@"Normal" fntFile:@"menus.fnt"];
    mediumLabel.position = [mediumButton convertToWorldSpace:ccp(box.width *0.5f, box.height*0.5f)];
    [difficultyLayer addChild:mediumLabel];
    
    //instructions button
    ButtonControl *hardButton = [ButtonControl buttonWithSpriteFrameName:@"placard.png" downFrameName:@"placard_on.png" target:self selectorStart:nil  selectorEnd:@selector(hardButtonPressed:)];
    
    [hardButton setIsTouchEnabled:YES];
    hardButton.position = ccp(screenSize.width * 0.54f, screenSize.height * 0.4f);
    [difficultyLayer addChild:hardButton];
    
    box = hardButton.boundingBox.size;
    CCLabelBMFont *hardLabel = [CCLabelBMFont labelWithString:@"Hard" fntFile:@"menus.fnt"];
    hardLabel.position = [hardButton convertToWorldSpace:ccp(box.width *0.5f, box.height*0.5f)];
    [difficultyLayer addChild:hardLabel];
    
    //back button
    ButtonControl *backButton = [ButtonControl buttonWithSpriteFrameName:@"placard.png" downFrameName:@"placard_on.png" target:self selectorStart:nil  selectorEnd:@selector(backButtonPressedToOptions:)];
    
    [backButton setIsTouchEnabled:YES];
    backButton.position = ccp(screenSize.width * 0.54f, screenSize.height * 0.3f);
    [difficultyLayer addChild:backButton];
    
    box = backButton.boundingBox.size;
    CCLabelBMFont *backLabel = [CCLabelBMFont labelWithString:@"Back" fntFile:@"menus.fnt"];
    backLabel.position = [backButton convertToWorldSpace:ccp(box.width *0.5f, box.height*0.5f)];
    [difficultyLayer addChild:backLabel];
    //*************************/
    
    
    CCSprite *backgroundPanel = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"instructions_bg.png"]];
    [backgroundPanel setPosition:ccp(screenSize.width / 3.7, screenSize.height / 2.35)];

    if([GameManager sharedGameManager].difficultyLevel >0)
        difficult = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"easy.png"]];
    else if([GameManager sharedGameManager].difficultyLevel == 0)
        difficult = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"med.png"]];
    else
        difficult = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"hard.png"]];
                
    
    
    [difficult setPosition:ccp(screenSize.width/3.8, 212)];
    
    [difficultyLayer addChild: backgroundPanel];
    [difficultyLayer addChild: difficult];
    //[self addChild:difficultyLayer];
    
    [difficultyLayer setPosition:ccp(120,0)];
    
    id addChild = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [self addChild:difficultyLayer];
        id  slideIn=[CCMoveBy actionWithDuration:0.1f position:ccp(-120, 0)];
        [difficultyLayer runAction:slideIn];
    }];
    
    [difficultyLayer runAction:[CCSequence actions: addChild, nil]];
    
}

-(void)easyButtonPressed:(id)sender {
   
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    [difficultyLayer removeChild:difficult cleanup:YES];
    
    difficult = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"easy.png"]];
    [difficult setPosition:ccp(screenSize.width/3.8, 212)];
    
    [difficultyLayer addChild: difficult];
    
    [GameManager sharedGameManager].difficultyLevel = kDifficultyEasy;

}
-(void)mediumButtonPressed:(id)sender {
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    [difficultyLayer removeChild:difficult cleanup:YES];
    
    difficult = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"med.png"]];
    [difficult setPosition:ccp(screenSize.width/3.8, 212)];
    [difficultyLayer addChild: difficult];
    [GameManager sharedGameManager].difficultyLevel = kDifficultyMed;

}
-(void)hardButtonPressed:(id)sender {   
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    [difficultyLayer removeChild:difficult cleanup:YES];
    
    difficult = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"hard.png"]];
    [difficult setPosition:ccp(screenSize.width/3.8, 212)];
    [difficultyLayer addChild: difficult];
    [GameManager sharedGameManager].difficultyLevel = kDifficultyHard;

}

-(void)playButtonPressed:(id)sender {
    GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
    gkHelper.delegate = nil;
    [GameManager sharedGameManager].hasPlayerDied = NO;
    [GameManager sharedGameManager].score = 0;
    [[GameManager sharedGameManager] runSceneWithID:kSpaceScene useLoadScene:YES];
    
}


-(void)optionsButtonPressed:(id)sender {
    
    //hide the main manu buttons
    [self hideMainMenuButtons];
    
    [self hidePreviousTextBlocks];
       
    //add other option menu items
    [self displayOptionsMenu:YES];
    
    [self setUpOptions];
    
}

-(void)objectiveButtonPressed:(id)sender {
   
    //hide the main manu buttons
    [mainMenuLayer removeChild:objectiveLayer cleanup:YES];
    
    //hide broward animation
    [self removeChild:broward cleanup:YES];
    
    objectiveLayer = [[CCLayer alloc] init];
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    CCSprite *objectivePanel = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"objective_bg.png"]];
    [objectivePanel setPosition:ccp(screenSize.width / 3.7, screenSize.height / 2.35)];
    
    objectiveLabel = [CCLabelBMFont labelWithString:@"Broward needs your \nhelp! He fell out of \nhis space ship and is \nquickly falling \ntowards the Earth! \nHe can only land \nsafely if you help him \nslow down. \n\nTo do this, you must \nguide him in hitting \nvarious objects in the \nsky that will slow his \nspeed...but be careful \nbecause some of the \nobjects deduct points! \n\nIf you miss objects, \nhis speed increases so \nhurry and try to hit \nas many as you can \nbefore he hits \nTerminal Velocity!" fntFile:@"recognition.fnt"];
    
    objectiveLabel.position = CGPointMake(screenSize.width / 3.65, screenSize.height / 2.4);
    
    [objectiveLayer addChild:objectivePanel];
    [objectiveLayer addChild:objectiveLabel];
    [mainMenuLayer addChild:objectiveLayer];
}


-(void)achievementButtonPressed:(id)sender{
    CCLOG(@"achievementButtonPressed:%@",[[UIDevice currentDevice] systemVersion]);
    GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];    
    [gkHelper showAchievements];
}

-(void)leadersBoardButtonPressed:(id)sender{
    CCLOG(@"leadersBoardButtonPressed:");
    GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
    //TESTING ONLY
    //[gkHelper submitScore:6933369 category:@"easyHighestScore"];
    /////////////////////////
    [gkHelper showLeaderboard];
}


#pragma mark INIT

-(id)init {
    self = [super init];
    if (self != nil) {
        
        [[SimpleAudioEngine sharedEngine] unloadEffect:@"gameEndScene.m4a"];
        
        [[GameMusicManager sharedMusicManager] playMusic];
        
         CGSize screenSize = [CCDirector sharedDirector].winSize;
    
        //facebook delegate
        delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
        //CCSpriteBatchNode *spriteBatchNode;
        CCSprite *backgroundImage;
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"menu_items.plist"];
        backgroundImage = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"menu_bg.png"]];
        
        
        [backgroundImage setPosition:ccp(screenSize.width/2.0f, screenSize.height/2.0f)];
        [self  addChild:backgroundImage z:0 tag:0];
        
        [self addAlienAnim];
        [self displayMainMenu];
        
        GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
		gkHelper.delegate = self;
		[gkHelper authenticateLocalPlayer];
        
        CCLayer *verLayer = [[CCLayer alloc] init];
        NSString *version = [[NSString alloc] initWithFormat:@"VERSION: %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
        [verLayer addChild:[CCLabelBMFont labelWithString:version  fntFile:@"recognition.fnt"]];
        [verLayer setPosition:ccp(screenSize.width*.68,screenSize.height*.74)];
        [ self addChild:verLayer];
        [version release];
        [verLayer release];
        
        [delegate rateApp];
        
    }
    return self;
}

@end
