//
//  SkySunsetLayer.m
//  TerminalVelocity
//
//  Created by Aaron Jones on 9/3/11.
//  Copyright (c) 2011 Dark Energy Studios. All rights reserved.
//

#import "SkySunsetLayer.h"

@implementation SkySunsetLayer

- (id)initWithColor:(ccColor4B)start fadingTo:(ccColor4B)end alongVector:(CGPoint)v {
    self = [super initWithColor:start fadingTo:end alongVector:v];
    if (self) {
        rr = start.r;
        gg = start.g;
        bb = start.b;
    
        r = end.r;
        g = end.g;
        b = end.b;
    }
    return self;
}

-(void)stepSunsetChange {
    if (b > 1) {
        b -= 2;
        self.endColor = ccc3(r, g, b);
    } 
    if (g > 75) {
        g -= 1;
        self.endColor = ccc3(r, g, b);
    } else {
        if (bb > 183) {
            self.startColor = ccc3(rr, gg, --bb);
        } else if (gg > 183) {
            self.startColor = ccc3(rr, --gg, bb);
        } else if (rr > 0){
            self.startColor = ccc3(--rr, --gg, --bb);
        }
    }
}

//layerWithColor:ccc4(0,183,183,255) fadingTo:ccc4(218,75,1,255)
//layerWithColor:ccc4(183,215,229,255) fadingTo:ccc4(218,242,255,255) 
-(void)stepSunRiseChange {
   
    if (b < 255) {
        b += 1;
        self.endColor = ccc3(r, g, b);
    } 
    if (g < 242) {
        self.endColor = ccc3(r, ++g, b);
    } else {
        if (bb < 229) {
            self.startColor = ccc3(rr, gg, ++bb);
        } else if (gg < 215) {
            self.startColor = ccc3(rr, ++gg, bb);
        } else if (rr < 183){
            self.startColor = ccc3(++rr, gg, bb);
        }
    }
}
@end
