//
//  DNUIViewContainer.m
//  DoubleNode.com
//
//  Created by Darren Ehlers on 10/11/12.
//  Copyright (c) 2012 DoubleNode.com. All rights reserved.
//

#import "DNUIViewContainer.h"

@implementation DNUIViewContainer

-(DNUIViewContainer*)initWithNibName:(NSString*)nibNameOrNil
                              bundle:(NSBundle*)nibBundleOrNil
{
    nibNameOrNil    = [DNUtilities appendNibSuffix:nibNameOrNil];
    
    if (nibBundleOrNil == nil)
    {
        nibBundleOrNil = [NSBundle mainBundle];
    }
    [nibBundleOrNil loadNibNamed:nibNameOrNil owner:self options:nil];

    return self;
}

@end
