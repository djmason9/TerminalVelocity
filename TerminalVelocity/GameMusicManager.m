//
//  GameMusicManager.m
//  TerminalVelocity
//
//  Created by Darren Mason on 8/24/11.
//  Copyright (c) 2011 Dark Energy Studios. All rights reserved.
//



#import "GameMusicManager.h"
#import "CDAudioManager.h"
#import "CDXPropertyModifierAction.h"


@implementation GameMusicManager

@synthesize listOfSoundEffectFiles;

static GameMusicManager *_sharedMusicManager = nil;
static CDAudioManager *am = nil;

+(GameMusicManager*)sharedMusicManager {
    @synchronized([GameMusicManager class])
    {
        if(!_sharedMusicManager)
            [[self alloc] init];
        return _sharedMusicManager;
    }
    return nil;
}

+(id)alloc
{
    @synchronized ([GameMusicManager class])
    {
        NSAssert(_sharedMusicManager == nil,
                 @"Attempted to allocate a second instance of the Music Manager singleton");
        _sharedMusicManager = [super alloc];
        return _sharedMusicManager;
    }
    return nil;
}

-(id)init {
    self = [super init];
    if (self != nil) {
        // Music Manager initialized
        am = [CDAudioManager sharedManager];
        [CDSoundEngine setMixerSampleRate:CD_SAMPLE_RATE_MID];
        [self loadSoundEffectsArray];
    }
    return self;
}

-(ALuint)playSoundEffect:(NSString*)soundEffectKey {
    return [[SimpleAudioEngine sharedEngine] playEffect:[listOfSoundEffectFiles objectForKey:soundEffectKey]];
    //return nil;
}

-(void)loadSoundEffectsArray{
    
    NSString *fullFileName = @"soundEffects.plist";
    NSString *plistPath;
    
    // 1: Get the Path to the plist file
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                         NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:fullFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] 
                     pathForResource:@"soundEffects" ofType:@"plist"];
    }
    
    // 2: Read in the plist file
    NSDictionary *plistDictionary = 
    [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    
    // 4. If the list of soundEffectFiles is empty, load it
    if ((listOfSoundEffectFiles == nil) || 
        ([listOfSoundEffectFiles count] < 1)) {
        NSLog(@"Before");
        [self setListOfSoundEffectFiles:[[NSMutableDictionary alloc] init]];
        
        NSLog(@"after");
        for (NSString *sceneSoundDictionary in plistDictionary) {
            [listOfSoundEffectFiles addEntriesFromDictionary: [plistDictionary objectForKey:sceneSoundDictionary]];
        }
        CCLOG(@"Number of SFX filenames:%d", 
              [listOfSoundEffectFiles count]);
    }
    

    // Get all of the entries and PreLoad // 3
    for( NSString *keyString in listOfSoundEffectFiles )
        [[SimpleAudioEngine sharedEngine] preloadEffect: [listOfSoundEffectFiles objectForKey:keyString]]; 
    
}

////(0-57.0) space,(57.0-105.5) sky,(105.5-138.5) rain ,(138.5-198.0) city;
-(void)setTimeThenPlay{

    CDLongAudioSource *player = [am audioSourceForChannel:kASC_Left];
    
    player.volume = 1.0f;
    [player.audioSourcePlayer play];
    
}

-(void)playMusic{
    
    SimpleAudioEngine *sae =  [SimpleAudioEngine sharedEngine];
    sae.backgroundMusicVolume = 1.0f;
    [sae playBackgroundMusic:MENU_SCENE_MUSIC_TRACK];
    
}


-(void)fadeOutMusicToNextSong:(int)playNextSong{
    
    if(!am.mute)//only do if not muted
    {
        
        id actionCallFuncN;
        
        switch (playNextSong) {
            case kSongSpace:
                actionCallFuncN = [CCCallFuncN actionWithTarget:self selector:@selector(callSpaceMusic:)];
                break;
            case kSongSky:
                actionCallFuncN = [CCCallFuncN actionWithTarget:self selector:@selector(callSkyMusic:)];
                break;
            case kSongRain:
                actionCallFuncN = [CCCallFuncN actionWithTarget:self selector:@selector(callRainMusic:)];
                break;
            case kSongCity:
                actionCallFuncN = [CCCallFuncN actionWithTarget:self selector:@selector(callCityMusic:)];
                break;
            case kSongNight:
                actionCallFuncN = [CCCallFuncN actionWithTarget:self selector:@selector(callNightMusic:)];
                break;
            case kSongEnd:
                actionCallFuncN = [CCCallFuncN actionWithTarget:self selector:@selector(endMusic:)];
                break;
                
            default:
                break;
        }
        
        CDLongAudioSource *player = [am audioSourceForChannel:kASC_Left];
        CDLongAudioSourceFader* fader = [[CDLongAudioSourceFader alloc] init:player interpolationType:kIT_Exponential startVal:player.volume endVal:0.3];
        [fader setStopTargetWhenComplete:YES];
        //Create a property modifier action to wrap the fader
        CDXPropertyModifierAction* action = [CDXPropertyModifierAction actionWithDuration:0.5 modifier:fader];
        [fader release];//Action will retain
        [[CCActionManager sharedManager] addAction:[CCSequence actions:action, actionCallFuncN, nil] target:player paused:NO];
       
    }
    
}

-(void)readyNextSong:(NSString *) songTitle{
    
    CDLongAudioSource *player = [am audioSourceForChannel:kASC_Left];
	[player load:songTitle];
}

#pragma mark Play songs methods

-(void)callSpaceMusic:(id)node{
    
    CDLongAudioSource *player = [am audioSourceForChannel:kASC_Left];
    [player load:SPACE_SCENE_MUSIC_TRACK];
    [self setTimeThenPlay];
}
-(void)callNightMusic:(id)node{
    CDLongAudioSource *player = [am audioSourceForChannel:kASC_Left];
    [player load:NIGHT_SCENE_MUSIC_TRACK];
    [self setTimeThenPlay];
}
-(void) endMusic:(id)node{
    CDLongAudioSource *player = [am audioSourceForChannel:kASC_Left];
    [player load:END_SCENE_MUSIC_TRACK];
    [self setTimeThenPlay];
}
-(void)callSkyMusic:(id)node{

    CDLongAudioSource *player = [am audioSourceForChannel:kASC_Left];
    [player load:SKY_SCENE_MUSIC_TRACK];
    [self setTimeThenPlay];
}

-(void)callRainMusic:(id)node{
    CDLongAudioSource *player = [am audioSourceForChannel:kASC_Left];
    [player load:RAIN_SCENE_MUSIC_TRACK];
    [self setTimeThenPlay];
}

-(void)callCityMusic:(id)node{
    [self setTimeThenPlay];
}

@end
