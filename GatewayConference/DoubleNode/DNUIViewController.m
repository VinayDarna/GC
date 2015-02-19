//
//  DNUIViewController.m
//  DoubleNode.com
//
//  Created by Darren Ehlers on 10/11/12.
//  Copyright (c) 2012 DoubleNode.com. All rights reserved.
//

#define DEBUGLOGGING
#import "DNUtilities.h"

#import "DNUIViewController.h"

@interface DNUIViewController ()

@end

@implementation DNUIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    nibNameOrNil    = [DNUtilities appendNibSuffix:nibNameOrNil];
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)subViewWillAppear:(BOOL)animated
{
    
}

- (void)subViewDidAppear:(BOOL)animated
{
    
}

- (void)subViewWillDisappear:(BOOL)animated
{
    
}

- (void)subViewDidDisappear:(BOOL)animated
{
    
}

@end
