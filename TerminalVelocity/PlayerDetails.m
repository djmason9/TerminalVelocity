//
//  PlayerDetails.m
//  TerminalVelocity
//
//  Created by Darren Mason on 10/4/11.
//  Copyright (c) 2011 Dark Energy Studios. All rights reserved.
//

#import "PlayerDetails.h"

@implementation PlayerDetails

@synthesize  alias,score,date;
    
- (id)init {
    self = [super init];
    if (self) {
        //
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
    [alias release];
    [score release];
    [date release];
}
@end
