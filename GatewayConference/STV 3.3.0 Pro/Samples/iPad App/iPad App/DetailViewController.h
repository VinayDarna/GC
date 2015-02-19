//
//  DetailViewController.h
//  iPad App
//
//  Copyright 2013 Sensible Cocoa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface DetailViewController : SCTableViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate> 
{
    UIPopoverController *popoverController;
}

@end
