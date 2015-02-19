//
//  iPadDetailViewController.m
//  Web Services App
//
//  Copyright (c) 2013 Sensible Cocoa. All rights reserved.
//

#import "iPadDetailViewController.h"

@implementation iPadDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the view controller's theme
    self.tableViewModel.theme = [SCTheme themeWithPath:@"foody-iPad-detail.sct"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
