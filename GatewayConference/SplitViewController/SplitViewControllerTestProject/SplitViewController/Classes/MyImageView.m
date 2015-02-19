//
//  MyImageView.m
//  steuerapp
//
//  Created by Bernhard Häussermann on 2011/04/24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyImageView.h"


@implementation MyImageView

@synthesize delegate,selector;


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [delegate performSelector:selector withObject:self withObject:touches];
}

@end
