//
//  GameOverLayer.mm
//  TerminalVelocity
//
//  Created by Aaron Jones on 8/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameOverLayer.h"
#import "GameManager.h"
#import "ButtonControl.h"
#import "GameKitHelper.h"
#import "GameMusicManager.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


@implementation GameOverLayer

@synthesize _tweetSheet;

static NSString *webSite =@"http://darkenergystudios.com";

-(void)dealloc{
    [_tweetSheet release];
    [super dealloc];
}

-(void)setVisible:(BOOL)visible {
    [super setVisible:visible];
    if (visible) {
        
        PLAYSOUNDEFFECT(END);
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
        gkHelper.delegate = self;
        
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        NSString *s1 = @"Final Score:";
       // NSString *s2 = [NSString stringWithFormat:@"%i points", [GameManager sharedGameManager].score];
        NSString *s3 = @"Highest Score:";
        NSString *s4 = @"Player Name:";
        
        GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
        
        NSString *s2 = [NSString stringWithFormat:@"%@ points", [self getFormatedScore]];
        
        CCLabelBMFont *l1 = [CCLabelBMFont labelWithString:s1 fntFile:@"deathscore.fnt"];
        CCLabelBMFont *l2 = [CCLabelBMFont labelWithString:s2 fntFile:@"deathscore.fnt"];
        CCLabelBMFont *l3 = [CCLabelBMFont labelWithString:s3 fntFile:@"deathscore.fnt"];
        CCLabelBMFont *l4 = [CCLabelBMFont labelWithString:s4 fntFile:@"deathscore.fnt"];
        CCLabelBMFont *l5 = [CCLabelBMFont labelWithString:localPlayer.alias fntFile:@"deathscore.fnt"];
        
        // final score
        l1.position = ccp(screenSize.width/2, screenSize.height * 0.4645);
        l2.position = ccp(screenSize.width/2, screenSize.height * 0.43125);
        
        // highest score
        l3.position = ccp(screenSize.width/2, screenSize.height * 0.3677);
        
        // player name
        l4.position = ccp(screenSize.width/2, screenSize.height * 0.2677);
        l5.position = ccp(screenSize.width/2, screenSize.height * 0.2375);
        
        [self addChild:l1];
        [self addChild:l2];
        [self addChild:l3];
        [self addChild:l4];
        [self addChild:l5];
        
        [gkHelper retrieveScoresForPlayers:nil category:nil range:NSMakeRange(1,1) playerScope:GKLeaderboardPlayerScopeGlobal timeScope:GKLeaderboardTimeScopeAllTime];
        
        float dif = [GameManager sharedGameManager].difficultyLevel;
        if(dif <= kDifficultyHard)
            [gkHelper submitScore:[GameManager sharedGameManager].score category:@"hardHighestScore"];
        else if(dif == kDifficultyMed)
            [gkHelper submitScore:[GameManager sharedGameManager].score category:@"medHighestScore"];
        else if(dif >= kDifficultyEasy)
            [gkHelper submitScore:[GameManager sharedGameManager].score category:@"easyHighestScore"];
        
        
        [menuButton setIsTouchEnabled:YES];
        [playButton setIsTouchEnabled:YES];
        [facebookButton setIsTouchEnabled:YES];
        [twitterButton setIsTouchEnabled:YES];
        
        //[TestFlight openFeedbackView];
    }
}


#pragma mark GAME CENTER GOODIES
-(void) onAchievementReported:(GKAchievement*)achievement
{
	//CCLOG(@"onAchievementReported: %@", achievement);
}

-(void) onScoresReceived:(NSArray*)scores
{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
	//CCLOG(@"onScoresReceived: %@", [scores description]);
    GKScore *score = [scores objectAtIndex:0];
    CCLabelBMFont *l1 = [CCLabelBMFont labelWithString:score.formattedValue fntFile:@"deathscore.fnt"];
    l1.position = ccp(screenSize.width/2, screenSize.height * 0.336);
    [self addChild:l1]; 
}

-(void) onScoresSubmitted:(bool)success
{
	//CCLOG(@"onScoresSubmitted: %@", success ? @"YES" : @"NO");
}

#pragma mark -

-(void)loadSpriteSheets {
    /*if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"death_menu_items.plist"];
        
    } else {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"death_menu_items.plist"];
        
    }*/
}

-(void)loadGameObjects {
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    [self loadSpriteSheets];
    
    CCSprite *deathScreenScore = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                                                  spriteFrameByName:@"deathscreen_score_bg.png"]];
    deathScreenScore.position = ccp(screenSize.width/2, screenSize.height*.3708);
    [self addChild:deathScreenScore];
    
    CCSprite *gameoverPlacard = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                                                                 spriteFrameByName:@"gameover_placard.png"]];
    gameoverPlacard.position = ccp(screenSize.width/2, screenSize.height*.5552);
    [self addChild:gameoverPlacard];
    
    float buttonspace = .10;
    float buttontop = .88;
    
    // play button
    playButton = [ButtonControl buttonWithSpriteFrameName:@"placard.png" downFrameName:@"placard_on.png" target:self selectorStart:nil  selectorEnd:@selector(playButtonPressed:)];
    playButton.anchorPoint = ccp(0.5,0.5);
    [playButton setIsTouchEnabled:NO];
    playButton.position = ccp(screenSize.width * 0.5f, screenSize.height * buttontop);
    [self addChild:playButton];
    
    CGSize box = playButton.boundingBox.size;
    CCLabelBMFont *playLabel = [CCLabelBMFont labelWithString:@"Play Again" fntFile:@"menus.fnt"];
    playLabel.position = [playButton convertToWorldSpace:ccp(box.width *0.5f, box.height*0.5f)];
    [self addChild:playLabel];
    
    // menu button
    menuButton = [ButtonControl buttonWithSpriteFrameName:@"placard.png" downFrameName:@"placard_on.png" target:self selectorStart:nil  selectorEnd:@selector(menuButtonPressed:)];
    menuButton.anchorPoint = ccp(0.5,0.5);
    [menuButton setIsTouchEnabled:NO];
    menuButton.position = ccp(screenSize.width * 0.5f, screenSize.height * (buttontop-buttonspace));
    [self addChild:menuButton];
    
    box = menuButton.boundingBox.size;
    CCLabelBMFont *menuLabel = [CCLabelBMFont labelWithString:@"Main Menu" fntFile:@"menus.fnt"];
    menuLabel.position = [menuButton convertToWorldSpace:ccp(box.width *0.5f, box.height*0.5f)];
    [self addChild:menuLabel];
    
    
    ////////// facebook /////////////
    facebookButton = [ButtonControl buttonWithSpriteFrameName:@"placard_facebook.png" downFrameName:@"placard_facebook_on.png" target:self selectorStart:nil  selectorEnd:@selector(facebookButtonPressed:)];
    facebookButton.anchorPoint = ccp(0.5,0.5);
    [facebookButton setIsTouchEnabled:NO];
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0"))
        //move over for twitter button to left
        facebookButton.position = ccp(screenSize.width * 0.26f, screenSize.height * (buttontop-(buttonspace*2)));
    else
        //centered
        facebookButton.position = ccp(screenSize.width * 0.5f, screenSize.height * (buttontop-(buttonspace*2)));    
    
    box = facebookButton.boundingBox.size;
    CCLabelBMFont *facebookLabel = [CCLabelBMFont labelWithString:@"Share" fntFile:@"menus.fnt"];
    facebookLabel.position = [facebookButton convertToWorldSpace:ccp(box.width *0.5f, box.height*0.5f)];
    
    if([[delegate facebook] isSessionValid])
    {
        [self addChild:facebookButton];
        [self addChild:facebookLabel];
    }
    
    ////////// twitter /////////////
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0") && [TWTweetComposeViewController canSendTweet])
    {        
        
        twitterButton = [ButtonControl buttonWithSpriteFrameName:@"placard_twitter.png" downFrameName:@"placard_twitter_on.png" target:self selectorStart:nil  selectorEnd:@selector(twitterButtonPressed:)];
        twitterButton.anchorPoint = ccp(0.5,0.5);
        [twitterButton setIsTouchEnabled:NO];
        
        if([[delegate facebook] isSessionValid])
            //move over for the facebook button to right
            twitterButton.position = ccp(screenSize.width * 0.74f, screenSize.height * (buttontop-(buttonspace*2)));
        else
            //center
            twitterButton.position = ccp(screenSize.width * 0.5f, screenSize.height * (buttontop-(buttonspace*2)));
        
        [self addChild:twitterButton];
        
        box = twitterButton.boundingBox.size;
        CCLabelBMFont *twitterLabel = [CCLabelBMFont labelWithString:@"Share" fntFile:@"menus.fnt"];
        twitterLabel.position = [twitterButton convertToWorldSpace:ccp(box.width *0.5f, box.height*0.5f)];
        [self addChild:twitterLabel];
    }
   
    
}

- (id)init {
    self = [super init];
    if (self) {
        delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        [self buildTweetSheet];
        [self loadGameObjects];
    }
    return self;
}

#pragma mark -
#pragma mark TWITTER
- (void)buildTweetSheet{
    
    /* make instance of tweet sheet */
    _tweetSheet = [[TWTweetComposeViewController alloc] init];
    
    //Specify the completion handler
    TWTweetComposeViewControllerCompletionHandler completionHandler = ^(TWTweetComposeViewControllerResult result){
        [delegate.viewController dismissModalViewControllerAnimated:YES];

    };
    
    [_tweetSheet setCompletionHandler:completionHandler];
}

+(BOOL)canSendTweet{
    
    BOOL _showTweetButton;
    /* Checks For Service Availability */ 
    if ([TWTweetComposeViewController canSendTweet] ) {
        // show my tweet button
        _showTweetButton = YES;
    }
    
    
    return _showTweetButton;
}


/* Sizing Notes
 
 - 140 characters maximum
 - Images and URLs use characters
 - currently uses 19 characters
 - URL Lengths could change; use return BOOLs!
 
 */

/* This method sets the initial text of the tweet  */
- (BOOL)setIntialText:(NSString *)text{
    
    BOOL allowed;
    
    // Try to set initial text
    allowed = [_tweetSheet setInitialText:text];
    
    return allowed;
}

/* Add Image To Image */
-(BOOL)addImageToSheet:(UIImage *)image{
    
    BOOL allowed;
    
    // Try to add an image to the sheet
    allowed = [_tweetSheet addImage:image];
    
    return allowed;
}

/* Setup URL Shortening  */

- (BOOL)addURLToSheet:(NSURL *)url{
    
    NSURL *newURL = [[NSURL alloc] initWithString:webSite];
    
    BOOL allowed;
    
    /* Try to add a URL to sheet, returns NO 
     if unsuccessful. */
    
    allowed = [_tweetSheet addURL:newURL];
    
    return allowed;
}

#pragma mark -

#pragma mark BUTTON PRESS METHODS
-(void)twitterButtonPressed:(id)sender{
    
    NSURL *url = [[NSURL alloc] initWithString:webSite]; 
    NSString *score = [[NSString alloc] initWithFormat:@"I just scored %@ in #TerminalVelocity!!! Beat that!",  [self getFormatedScore]];
    
    [_tweetSheet addImage:[UIImage imageNamed:@"Icon@2x.png"]];
    [_tweetSheet setInitialText:score];
    [_tweetSheet addURL:url];
    
    
    // Show our tweet sheet
    [delegate.viewController presentModalViewController:_tweetSheet animated:YES];
    
}

-(NSString *)getFormatedScore{

    NSNumber *result = [NSNumber numberWithFloat: [GameManager sharedGameManager].score];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSString *resultText =[numberFormatter stringFromNumber:result];
    
    return resultText;

}

-(void)facebookButtonPressed:(id)sender {
    
    NSString *iconlocation = [[NSString alloc] initWithFormat:@"%@/images/Icon@2x.png",webSite];
    
    NSString *caption =  [[NSString alloc] initWithFormat:@"I just scored %@ points on Terminal Velocity!", [self getFormatedScore]];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   //kAppId, @"app_id",
                                   iconlocation,@"picture",
                                   webSite,@"link",
                                   caption,@"caption",
                                   @"I just played Terminal Velocity and I'm better than you. Don't believe me? Prove it!",@"description",nil];
    
    [[delegate facebook] dialog:@"feed" andParams:params andDelegate:self];
    
}

-(void)menuButtonPressed:(id)sender {
    [[GameManager sharedGameManager] runSceneWithID:kMainMenuScene];
}

-(void)playButtonPressed:(id)sender {
    [[SimpleAudioEngine sharedEngine] unloadEffect:@"gameEndScene.m4a"];
    [GameManager sharedGameManager].hasPlayerDied = NO;
    [GameManager sharedGameManager].score = 0;
    [[GameManager sharedGameManager] runSceneWithID:kSpaceScene useLoadScene:YES];
}
#pragma mark -

@end
