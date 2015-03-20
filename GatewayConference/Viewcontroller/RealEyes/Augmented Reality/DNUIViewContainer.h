//
//  DNUIViewContainer.h
//  DoubleNode.com
//
//  Created by Darren Ehlers on 10/11/12.
//  Copyright (c) 2012 DoubleNode.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DNUIViewContainer : NSObject

@property (nonatomic, retain) IBOutlet UIView*  view;

-(DNUIViewContainer*)initWithNibName:(NSString*)nibNameOrNil
                              bundle:(NSBundle*)nibBundleOrNil;

@end
