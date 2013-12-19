//
//  ButtonControl.h
//  HoboHero
//
//  Created by Aaron Jones on 3/5/10.
//  Copyright 2010 BSquaredsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum tagControlState {
	kControlUp,
	kControlDown
} ControlState;


@interface ButtonControl : CCNode <CCTargetedTouchDelegate> {
	CCSprite *buttonUp;
	CCSprite *buttonDown;
	ControlState state;
	BOOL isTouchEnabled;
	id targetNode;
	SEL selStart;
	SEL selEnd;
}

@property(nonatomic, retain) CCSprite *buttonUp;
@property(nonatomic, retain) CCSprite *buttonDown;
@property(nonatomic, readonly) CGRect rect;
@property(nonatomic, readonly) ControlState state;
@property(nonatomic, retain) id targetNode;
@property SEL selStart;
@property SEL selEnd;
//@property(nonatomic, readwrite) CGPoint postion;
//@property(nonatomic, readwrite) CGPoint anchorPoint;
@property(nonatomic, readwrite) BOOL isTouchEnabled;

-(id)initWithFile:(NSString *)file downFile:(NSString *)downFile target:(id)target selectorStart:(SEL)selectorStart selectorEnd:(SEL)selectorEnd;
-(id)initWithSpriteFrameName:(NSString *)frameName downFrameName:(NSString *)downFrameName target:(id)target selectorStart:(SEL)selectorStart selectorEnd:(SEL) selectorEnd;
+(id)buttonWithFile:(NSString *)file downFile:(NSString *)downFile target:(id)target selectorStart:(SEL)selectorStart selectorEnd:(SEL)selectorEnd;
+(id)buttonWithFile:(NSString *)file target:(id)target selectorStart:(SEL)selectorStart selectorEnd:(SEL)selectorEnd;
+(id)buttonWithFile:(NSString *)file target:(id)target selectorStart:(SEL)selectorStart;
+(id)buttonWithSpriteFrameName:(NSString *)frameName downFrameName:(NSString *)downFrameName target:(id)target selectorStart:(SEL)selectorStart selectorEnd:(SEL)selectorEnd;

@end
