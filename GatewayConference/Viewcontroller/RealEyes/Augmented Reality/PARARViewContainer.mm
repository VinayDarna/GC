//
//  PARARViewContainer.m
//  Parley
//
//  Created by Darren Ehlers on 3/3/13.
//  Copyright (c) 2013 Gateway Church. All rights reserved.
//

#import "PARARViewContainer.h"
#import "PARQCARutils.h"
#import "PARAppDelegate.h"
#import "PARARTarget.h"
#import "DNImageCache.h"
#import "Flurry.h"
#import "PARParentViewController.h"

@implementation PARARViewContainer

-(DNUIViewContainer*)initWithNibName:(NSString*)nibNameOrNil
                              bundle:(NSBundle*)nibBundleOrNil
                            delegate:(id<PARARViewContainerDelegate>)delegateOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        delegate = delegateOrNil;
    }
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    self.btnARStart.enabled = YES;

    [UIView animateWithDuration:0.3f
                     animations:^
     {
         self.imgBackground.alpha = 1.0f;
     }];
}

- (IBAction)launchAction:(id)sender
{
    if ([[PARAppDelegate appDelegate] isReachable] == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Unavailable"
                                                        message:@"Your device is not currently able to reach our RealEyes server.  Please try again later..."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if ([[PARAppDelegate appDelegate] isARDataDownloaded] == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"RealEyes Not Ready"
                                                        message:@"The RealEyes Configuration Data is still downloading.  Please try again in a minute or two..."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    self.btnARStart.enabled = NO;
    
    [UIView animateWithDuration:0.3f
                     animations:^
     {
         self.imgBackground.alpha   = 0.0f;
     }];
    
    
    [Flurry logEvent:@"RealEyes Launched"];

    CATransition*   shutterAnimation = [CATransition animation];
    [shutterAnimation setDelegate:self];
    [shutterAnimation setDuration:0.6];
    
    shutterAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [shutterAnimation setType:@"cameraIris"];
    [shutterAnimation setValue:@"cameraIris" forKey:@"cameraIris"];
    
    CALayer*    cameraShutter = [[CALayer alloc]init];
    [cameraShutter setBounds:CGRectMake(0.0, 0.0, 320.0, 425.0)];
    [self.view.layer addSublayer:cameraShutter];
    [self.view.layer addAnimation:shutterAnimation forKey:@"cameraIris"];
    
    PARQCARutils*   qUtils = [PARQCARutils getInstance];
    qUtils.deviceOrientationLock = DeviceOrientationLockAuto;
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    //get the documents directory:
    NSArray*  paths               = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory  = [paths objectAtIndex:0];
    NSString* filename            = [NSString stringWithFormat:@"%@/ARDatabase.xml", documentsDirectory];

    // Provide a list of targets we're expecting - the first in the list is the default
    NSArray*    arTargets = [PARARTarget getAll];
    [arTargets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         PARARTarget*   target = obj;
         
         [qUtils addTargetName:target.name atPath:filename];
     }];
    
    if (arParentViewController == nil)
    {
        // Add the EAGLView and the overlay view to the window
        arParentViewController = [[PARParentViewController alloc] init];
        arParentViewController.arViewRect = screenBounds;
        arParentViewController.parentDelegate   = self;
    }
    
    [[PARAppDelegate appDelegate] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    [delegate presentViewController:arParentViewController animated:YES completion:^
     {
         self.btnClose.alpha  = 0.0f;
     }];
}

- (IBAction)closeAction:(id)sender
{
    [self arClose];
}

- (void)arClose
{
    [[PARAppDelegate appDelegate] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];

    if([delegate respondsToSelector:@selector(arClose)])
    {
        [delegate arClose];
    }
}

@end
