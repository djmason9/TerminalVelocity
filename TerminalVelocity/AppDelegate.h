//
//  AppDelegate.h
//  TerminalVelocity
//
//  Created by Aaron Jones on 6/21/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    
    Facebook *facebook;
}
@property (nonatomic,retain) RootViewController	*viewController;
@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) UIWindow *window;
-(void)preLoadCachedFonts;
- (void)rateApp;
@end
