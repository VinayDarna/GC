//
//  DNUIViewController.h
//  DoubleNode.com
//
//  Created by Darren Ehlers on 10/11/12.
//  Copyright (c) 2012 DoubleNode.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DNUtilities.h"

@interface DNUIViewController : UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil;

- (void)subViewWillAppear:(BOOL)animated;
- (void)subViewDidAppear:(BOOL)animated;

- (void)subViewWillDisappear:(BOOL)animated;
- (void)subViewDidDisappear:(BOOL)animated;

@end
