//
//  GameMusicManager.h
//  TerminalVelocity
//
//  Created by Darren Mason on 8/24/11.
//  Copyright (c) 2011 Dark Energy Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDXPropertyModifierAction.h"
#import "Constants.h"

#define SKY_SCENE_MUSIC_TRACK @"skyScene8.aiff"
#define RAIN_SCENE_MUSIC_TRACK @"rainScene8.aiff"
#define NIGHT_SCENE_MUSIC_TRACK @"nightScene8.aiff"
#define SPACE_SCENE_MUSIC_TRACK @"spaceScene.m4a"
#define CITY_SCENE_MUSIC_TRACK @"cityScene.m4a"
#define MENU_SCENE_MUSIC_TRACK @"menuScene.m4a"
#define END_SCENE_MUSIC_TRACK @"gameEndScene.m4a"

#define PLAYSOUNDEFFECT(...) \
[[GameMusicManager sharedMusicManager] playSoundEffect:@#__VA_ARGS__]

@interface GameMusicManager : NSObject{  
    NSMutableDictionary *listOfSoundEffectFiles;
}

+(GameMusicManager*) sharedMusicManager;
@property (nonatomic, retain) NSMutableDictionary *listOfSoundEffectFiles;
-(void)playMusic;
-(void)readyNextSong:(NSString *) songTitle;
-(void)setTimeThenPlay;
-(void)fadeOutMusicToNextSong:(int)playNextSong;
-(void)loadSoundEffectsArray;
-(ALuint)playSoundEffect:(NSString*)soundEffectKey;
@end
