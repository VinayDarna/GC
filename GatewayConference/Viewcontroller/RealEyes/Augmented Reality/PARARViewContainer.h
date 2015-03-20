//
//  PARARViewContainer.h
//  Parley
//
//  Created by Darren Ehlers on 3/3/13.
//  Copyright (c) 2013 Gateway Church. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>

#import "DNUIViewContainer.h"

#import "PARParentViewController.h"

@protocol PARARViewContainerDelegate;

@interface PARARViewContainer : DNUIViewContainer <ARParentViewControllerDelegate>
{
    id<PARARViewContainerDelegate> delegate;
    
    PARParentViewController*    arParentViewController;
}

@property (nonatomic, retain) IBOutlet UIImageView* imgBackground;
@property (nonatomic, retain) IBOutlet UIButton*    btnARStart;
@property (nonatomic, retain) IBOutlet UIButton*    btnClose;

- (void)viewDidAppear:(BOOL)animated;

-(DNUIViewContainer*)initWithNibName:(NSString*)nibNameOrNil
                              bundle:(NSBundle*)nibBundleOrNil
                            delegate:(id<PARARViewContainerDelegate>)delegateOrNil;

@end

@protocol PARARViewContainerDelegate <NSObject>

- (void)presentViewController:(UIViewController*)viewControllerToPresent
                     animated:(BOOL)flag
                   completion:(void (^)(void))completion;

- (void)arLaunch;
- (void)arClose;

@end