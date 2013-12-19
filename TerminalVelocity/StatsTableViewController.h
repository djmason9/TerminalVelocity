//
//  StatsTableViewController.h
//  TerminalVelocity
//
//  Created by Darren Mason on 10/3/11.
//  Copyright (c) 2011 Dark Energy Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatsTableViewController : UITableViewController
{
    
    NSArray *statsArray;
}

@property(nonatomic,retain)NSArray *statsArray;
@end
