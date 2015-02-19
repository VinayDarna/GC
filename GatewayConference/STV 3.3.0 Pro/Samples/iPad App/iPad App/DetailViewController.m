//
//  DetailViewController.m
//  iPad App
//
//  Copyright 2013 Sensible Cocoa. All rights reserved.
//

#import "DetailViewController.h"
#import "RootViewController.h"




@implementation DetailViewController

@synthesize popoverController;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.popoverController = nil;
}


#pragma mark -
#pragma mark Split view support

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    
    barButtonItem.title = @"Tasks";
    self.navigationItem.leftBarButtonItem = barButtonItem;
	
    self.popoverController = pc;
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
	self.navigationItem.leftBarButtonItem = nil;
	
	self.popoverController = nil;
}



@end
