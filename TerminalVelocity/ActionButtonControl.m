//
//  ActionButtonControl.m
//  TerminalVelocity
//
//  Created by Aaron Jones on 8/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ActionButtonControl.h"

@implementation ActionButtonControl

@synthesize actionItemDelegate;

- (void)dealloc {
    [actionItemDelegate release];
    [super dealloc];
}

+(id)buttonWithSpriteFrameName:(NSString *)frameName downFrameName:(NSString *)downFrameName target:(id)target selectorStart:(SEL)selectorStart selectorEnd:(SEL)selectorEnd {
    return [[ActionButtonControl alloc] initWithSpriteFrameName:frameName downFrameName:downFrameName target:target selectorStart:selectorStart selectorEnd:selectorEnd];
}


/*
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    [super ccTouchBegan:touch withEvent:event];
    [actionItemDelegate decrementActionItem];
}
 */

/*
-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    [super ccTouchEnded:touch withEvent:event];
    [actionItemDelegate decrementActionItem];
}
 */

- (BOOL)containsTouchLocation:(UITouch *)touch {
	CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    touchLocation = CGPointMake(touchLocation.x + 55, touchLocation.y + 75);
	return CGRectContainsPoint(self.rect, touchLocation);
}

-(CGRect)rect {
	CGSize s = self.buttonUp.boundingBox.size;
	CGRect r = CGRectMake(self.buttonUp.anchorPoint.x , self.buttonUp.anchorPoint.y+20, s.width + 55, s.height+75);
	return r;
}
@end
