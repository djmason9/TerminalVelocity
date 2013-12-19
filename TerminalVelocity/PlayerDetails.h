//
//  PlayerDetails.h
//  TerminalVelocity
//
//  Created by Darren Mason on 10/4/11.
//  Copyright (c) 2011 Dark Energy Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerDetails : NSObject
{
    NSString *alias;
    NSNumber *score;
    NSDate *date;
}
@property(nonatomic,retain)NSString *alias;
@property(nonatomic,retain)NSNumber *score;
@property(nonatomic,retain)NSDate *date;
@end
