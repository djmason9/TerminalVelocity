//
//  ButtonControl.m
//  HoboHero
//
//  Created by Aaron Jones on 3/5/10.
//  Copyright 2010 . All rights reserved.
//

#import "ButtonControl.h"
#import "GameMusicManager.h"

@implementation ButtonControl
@synthesize buttonUp;
@synthesize buttonDown;
@synthesize state;
@synthesize targetNode;
@synthesize selStart;
@synthesize selEnd;



-(id)initWithFile:(NSString *)file downFile:(NSString *)downFile target:(id)target selectorStart:(SEL)selectorStart selectorEnd:(SEL)selectorEnd {
	if ((self = [super init])) {
		state = kControlUp;
		self.buttonUp = [CCSprite spriteWithFile:file];
		
		if(downFile != nil) {
			self.buttonDown = [CCSprite spriteWithFile:downFile];
		}
		isTouchEnabled = NO;
		targetNode = target;
		selStart = selectorStart;
        [self setContentSize: [buttonUp contentSize]];
		
		if (selectorEnd != nil) {
			selEnd = selectorEnd;
		}
	}
	return self;
}

-(id)initWithSpriteFrameName:(NSString *)frameName downFrameName:(NSString *)downFrameName target:(id)target selectorStart:(SEL)selectorStart selectorEnd:(SEL) selectorEnd {
    if ((self = [super init])) {
		state = kControlUp;
        assert(frameName != nil);
		self.buttonUp = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
		
		if(downFrameName != nil) {
			self.buttonDown = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:downFrameName]];
		}
		isTouchEnabled = NO;
		targetNode = target;
		selStart = selectorStart;
        [self setContentSize: [buttonUp contentSize]];
		
		if (selectorEnd != nil) {
			selEnd = selectorEnd;
		}
	}
	return self;
}

+(id)buttonWithFile:(NSString *)file target:(id)target selectorStart:(SEL)selectorStart {
	return [ButtonControl buttonWithFile:file downFile:nil target:target selectorStart:selectorStart selectorEnd:nil];
}

+(id)buttonWithFile:(NSString *)file downFile:(NSString *)downFile
			target:(id)target selectorStart:(SEL)selectorStart selectorEnd:(SEL)selectorEnd {
	return [[ButtonControl alloc] initWithFile:file downFile:downFile
										target:target selectorStart:selectorStart selectorEnd:selectorEnd];
}

+(id)buttonWithFile:(NSString *)file target:(id)target selectorStart:(SEL)selectorStart selectorEnd:(SEL)selectorEnd {
	return [[ButtonControl alloc] initWithFile:file downFile:nil target:target selectorStart:selectorStart selectorEnd:selectorEnd];
}

+(id)buttonWithSpriteFrameName:(NSString *)frameName downFrameName:(NSString *)downFrameName target:(id)target selectorStart:(SEL)selectorStart selectorEnd:(SEL)selectorEnd {
    return [[ButtonControl alloc] initWithSpriteFrameName:frameName downFrameName:downFrameName target:target selectorStart:selectorStart selectorEnd:selectorEnd];
}

-(id) initWithTexture:(CCTexture2D *)aTexture {
	if ((self = [super init]) ) {		
		state = kControlUp;
	}
	return self;
}

-(void) draw {
	if (state == kControlUp) {
		[buttonUp draw];
	} else if (state == kControlDown && buttonDown != nil){
		[buttonDown draw];
	} else {
		[buttonUp draw];
	}

}

-(CGRect)rect {
	CGSize s = self.buttonUp.boundingBox.size;
	CGRect r = CGRectMake(self.buttonUp.anchorPoint.x , self.buttonUp.anchorPoint.y, s.width, s.height);
	return r;
}

-(CGPoint)position {
	return buttonUp.position;
}
-(void)setPosition:(CGPoint) p {
    [super setPosition:p];
	buttonUp.position = p;
	buttonDown.position = p;
}

-(CGPoint)anchorPoint {
	return buttonUp.anchorPoint;
}

-(void)setAnchorPoint:(CGPoint) p {
    [super setAnchorPoint:p];
	buttonUp.anchorPoint = p;
	buttonDown.anchorPoint = p;
}

-(void) setIsTouchEnabled:(BOOL)enabled {
    
	if( isTouchEnabled != enabled ) {
		isTouchEnabled = enabled;
		if( isRunning_ ) {
			if( enabled )
				[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
			else
				[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
		}
	}
}

-(BOOL) isTouchEnabled {
	return isTouchEnabled;
}

- (BOOL)containsTouchLocation:(UITouch *)touch {
	CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
	return CGRectContainsPoint(self.rect, touchLocation);
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
 
	BOOL b = NO;
	if (state != kControlUp) {
		b = NO;
	} else if ( ![self containsTouchLocation:touch] ) {
		b = NO;
	} else {
		b = YES;
		state = kControlDown;
        if (selStart != nil) {
            [targetNode performSelector:selStart];
        }
        //play sound this is here so all buttons have a click sound but it could be moved to a better spot. dicko ;-)
        PLAYSOUNDEFFECT(BUTTON_DOWN);
		
	}

	return b;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
	state = kControlUp;
	if (selEnd != nil) {
		[targetNode performSelector:selEnd];
	}
}

- (void)onEnter {
	if( isTouchEnabled )
		[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	
	[super onEnter];
}

- (void)onExit {
	if( isTouchEnabled )
		[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	
	[super onExit];
}

- (void)dealloc {
	NSLog(@"deallocing - ButtonControl:%@", self);
	[buttonUp release];
	[buttonDown release];
	[super dealloc];
}

@end
