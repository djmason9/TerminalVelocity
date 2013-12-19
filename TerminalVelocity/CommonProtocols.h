//
//  CommonProtocols.h
//  TerminalVelocity
//
//  Created by Aaron Jones on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@protocol GameplayLayerDelegate <NSObject>
-(int)getActionCount;
-(void)resetActionItems;
-(void)registerGameObjectTarget:(id)target action:(GameActionControl)action selector:(SEL)selector;
-(void)decrementActionItem;
@end