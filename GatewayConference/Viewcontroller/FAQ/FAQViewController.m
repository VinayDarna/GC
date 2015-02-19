//
//  FAQViewController.m
//  GatewayConference
//
//  Created by Olive Tech on 19/02/15.
//  Copyright (c) 2015 Teja Swaroop. All rights reserved.
//

#import "FAQViewController.h"

@interface FAQViewController ()

@end

@implementation FAQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    if ([[GCSharedClass sharedInstance]checkNetworkAndProceed:self])
    {
        [self getFAQDetails];
    }
    else
    {
        NSLog(@"Error in fetching");
    }

}

-(void)getFAQDetails
{
    [[GCSharedClass sharedInstance]showGlobalProgressHUDWithTitle:@"Loading..."];
    
    [[GCSharedClass sharedInstance]fetchDetailsWithParameter:url_Faq andReturnWith:^(NSMutableArray *faqArray, BOOL Success)
     {
         if (Success)
         {
             [[GCSharedClass sharedInstance] dismissGlobalHUD];
             
             NSLog(@"FAQ %@",faqArray);
         }
         else
         {
             UIAlertView *Alert = [[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Data can't be Fetched" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [Alert show];
             [[GCSharedClass sharedInstance] dismissGlobalHUD];
         }
     }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
  
}


@end
