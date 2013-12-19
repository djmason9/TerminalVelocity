//
//  MenuLayer.m
//  TerminalVelocity
//
//  Created by Darren Mason on 10/26/11.
//  Copyright (c) 2011 Dark Energy Studios. All rights reserved.
//

#import "MenuLayer.h"
#import "PlayerDetails.h"
#import "StatsTableViewController.h"

@implementation MenuLayer


#pragma mark -
#pragma mark GameCenter Methods 
-(void) onLocalPlayerAuthenticationChanged
{
	GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
	CCLOG(@"LocalPlayer isAuthenticated changed to: %@", localPlayer.authenticated ? @"YES" : @"NO");
	
	if (localPlayer.authenticated)
	{
		GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
		[gkHelper getLocalPlayerFriends];
        [mainMenuLayer removeChild:statsButton cleanup:YES];
        [mainMenuLayer addChild:statsButton];
	}
	else
        [mainMenuLayer removeChild:statsButton cleanup:YES];

}

-(void) onFriendListReceived:(NSArray*)friends
{
	CCLOG(@"onFriendListReceived: %@", [friends description]);
	//GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
	//[gkHelper getPlayerInfo:friends];
}

-(void)noPlayerScoreRecieved{
    [easyTab setIsTouchEnabled: YES];
    [normalTab setIsTouchEnabled:YES];
    [hardTab setIsTouchEnabled:YES];
}

-(void) onPlayerInfoReceived:(NSArray*)players
{
	CCLOG(@"onPlayerInfoReceived: %@", [players description]);
    
    if([statsLayer isRunning])// Add View To Scene
    {
        NSMutableArray *playerDetail =  [[NSMutableArray alloc] init];
        
        NSUInteger count = [players count];
        
        NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
        
        //Set the required date format
        
        [formatter setDateFormat:@"MM/dd/yy"];
        
        //Get the string date
        
        
        
        for(NSUInteger i=0;i<count;i++)
        {
            GKPlayer *p = [players objectAtIndex:i];
            GKScore *s = [_scores objectAtIndex:i];
            
            PlayerDetails *pd = [[PlayerDetails alloc] init];
            if(p.alias.length >12)
                pd.alias = [[NSString alloc] initWithFormat:@"%@...",[p.alias substringToIndex:12]];
            else
                pd.alias = p.alias;
            
            pd.date = s.date;
            pd.score =[NSNumber numberWithInteger:s.value];
            [playerDetail addObject:pd];
            [pd release];
        }
        
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        //CCLOG(@"onScoresReceived: %@",[scores description]);
        CGRect rect = CGRectMake(screenSize.width *.1, screenSize.height*.49, screenSize.width*.8, screenSize.height*.30);
        
        StatsTableViewController *tableController = [[StatsTableViewController alloc] init];
        
        tableController.statsArray = playerDetail;
        [playerDetail release];
        
        
        tableView = tableController.tableView;
        tableView.separatorColor = [UIColor grayColor];
        [tableView setFrame:rect];
        // Set TableView Attributes
        tableView.backgroundColor = [UIColor clearColor];
        tableView.opaque = YES;
        
        
        
        [[[CCDirector sharedDirector] openGLView] addSubview:tableView];

        [easyTab setIsTouchEnabled: YES];
        [normalTab setIsTouchEnabled:YES];
        [hardTab setIsTouchEnabled:YES];
    }
    else
        [tableView removeFromSuperview];
    
}

-(void) onScoresSubmitted:(bool)success
{
	//CCLOG(@"onScoresSubmitted: %@", success ? @"YES" : @"NO");
}

-(void) onScoresReceived:(NSArray*)scores
{
    NSMutableArray *players = [[NSMutableArray alloc] init];
    _scores = [[NSMutableArray alloc] init];
    
    NSUInteger count = [scores count];
    
    for (NSUInteger i = 0; i < count; i++) {
        
        GKScore *score = [scores objectAtIndex: i];
        [players addObject:score.playerID];
        
        //NSLog(@"CAT:%@",score.category);
        //NSLog(@"%i",i);
        [_scores addObject:score];
        
    }
    
    GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
	[gkHelper getPlayerInfo:players];
    [players release];
    
}




-(void) onAchievementReported:(GKAchievement*)achievement
{
	//CCLOG(@"onAchievementReported: %@", achievement);
}

-(void) onAchievementsLoaded:(NSDictionary*)achievements
{
	//CCLOG(@"onLocalPlayerAchievementsLoaded: %@", [achievements description]);
    
}

-(void) onResetAchievements:(bool)success
{
	//CCLOG(@"onResetAchievements: %@", success ? @"YES" : @"NO");
}

-(void) onLocalPlayerScoreReceived:(GKScore *)score {
    CCLOG(@"onLocalPlayerScoreReceived: %@", score);
}

-(void) onLeaderboardViewDismissed
{
	//CCLOG(@"onLeaderboardViewDismissed");
    [self addGameCenterButtons];  
}

-(void) onAchievementsViewDismissed
{
	//CCLOG(@"onAchievementsViewDismissed");
    [self addGameCenterButtons];  
}

-(void) onReceivedMatchmakingActivity:(NSInteger)activity
{
	//CCLOG(@"receivedMatchmakingActivity: %i", activity);
}

-(void) onMatchFound:(GKMatch*)match
{
	//CCLOG(@"onMatchFound: %@", match);
}

-(void) onPlayersAddedToMatch:(bool)success
{
	//CCLOG(@"onPlayersAddedToMatch: %@", success ? @"YES" : @"NO");
}

-(void) onMatchmakingViewDismissed
{
	//CCLOG(@"onMatchmakingViewDismissed");
}
-(void) onMatchmakingViewError
{
	//CCLOG(@"onMatchmakingViewError");
}

-(void) onPlayerConnected:(NSString*)playerID
{
	//CCLOG(@"onPlayerConnected: %@", playerID);
}

-(void) onPlayerDisconnected:(NSString*)playerID
{
	//CCLOG(@"onPlayerDisconnected: %@", playerID);
}

-(void) onStartMatch
{
	//CCLOG(@"onStartMatch");
}
#pragma mark -

- (void)dealloc {
    [_scores release];
    [super dealloc];
}

@end
