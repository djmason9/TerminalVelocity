//
//  SkySunsetLayer.h
//  TerminalVelocity
//
//  Created by Aaron Jones on 9/3/11.
//  Copyright (c) 2011 Dark Energy Studios. All rights reserved.
//

#import "cocos2d.h"

@interface SkySunsetLayer : CCLayerGradient {
    //end 218,242,255
    GLubyte r;
    GLubyte g;
    GLubyte b;
    
    //start 183,215,229
    GLubyte rr;
    GLubyte gg;
    GLubyte bb;
}
-(void)stepSunsetChange;
-(void)stepSunRiseChange;
@end
