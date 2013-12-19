//
//  GameOverLayer.h
//  TerminalVelocity
//
//  Created by Aaron Jones on 8/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CCLayer.h"
#import "GameKitHelper.h"
#import "cocos2d.h"
#import "ButtonControl.h"
#import "FBConnect.h"
#import "AppDelegate.h"
#import "MenuLayer.h"
#import <Twitter/TWTweetComposeViewController.h>

@interface GameOverLayer : MenuLayer <GameKitHelperProtocol,FBDialogDelegate>
{
    ButtonControl *playButton;
    ButtonControl *menuButton;
    ButtonControl *facebookButton;
    ButtonControl *twitterButton;
    AppDelegate *delegate;    
    TWTweetComposeViewController *_tweetSheet;
    BOOL _showTweetButton;
}

@property(nonatomic,retain)TWTweetComposeViewController *_tweetSheet;

-(void)loadGameObjects;
- (void)buildTweetSheet;
-(NSString *)getFormatedScore;

-(IBAction)presentTweetSheet:(id)sender;
- (void)buildTweetSheet;
- (BOOL)addURLToSheet:(NSURL *)url;
-(BOOL)addImageToSheet:(UIImage *)image;
- (BOOL)setIntialText:(NSString *)text;


@end
