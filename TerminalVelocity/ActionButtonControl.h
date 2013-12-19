//
//  ActionButtonControl.h
//  TerminalVelocity
//
//  Created by Aaron Jones on 8/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ButtonControl.h"

@interface ActionButtonControl : ButtonControl {
    id actionItemDelegate;
}
@property(nonatomic, retain) id actionItemDelegate;
@end
