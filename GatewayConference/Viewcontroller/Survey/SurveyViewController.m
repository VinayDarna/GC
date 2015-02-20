//
//  SurveyViewController.m
//  GatewayConference
//
//  Created by Olive Tech on 13/01/15.
//  Copyright (c) 2015 Teja Swaroop. All rights reserved.
//

#import "SurveyViewController.h"

@interface SurveyViewController ()

@end

@implementation SurveyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[GCSharedClass sharedInstance]showGlobalProgressHUDWithTitle:@"Loading..."];
    self.surveyWebView.delegate = self;
    
    [self.surveyWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.surveymonkey.com/user/sign-in/"]]];
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[GCSharedClass sharedInstance] dismissGlobalHUD];

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[GCSharedClass sharedInstance] dismissGlobalHUD];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
