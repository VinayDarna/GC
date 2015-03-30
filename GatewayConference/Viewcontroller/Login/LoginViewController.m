//
//  LoginViewController.m
//  GatewayConference
//
//  Created by Olive Tech on 05/03/15.
//  Copyright (c) 2015 Teja Swaroop. All rights reserved.
//

#import "LoginViewController.h"

#import "DashBoardViewController.h"

#import "SlideMenu.h"

#import "UIViewController+RESideMenu.h"

#import <Accounts/Accounts.h>

#import "STTwitterAPI.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    [effectView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+20)];
    [self.imageView addSubview:effectView];
    appObj = [UIApplication sharedApplication].delegate;
    dash = [[DashBoardViewController alloc] init];
}

- (IBAction)loginWithFacebook:(id)sender {
    
    appObj.checktheId = NO;
    
    if ([[GCSharedClass sharedInstance]checkNetworkAndProceed:self])
    {
        if(!appObj.session.isOpen)
        {
            appObj.session = [[FBSession alloc] initWithPermissions:[NSArray arrayWithObjects:@"user_events",@"rsvp_event",@"publish_stream",@"friends_events",@"public_profile", @"email",nil]];
            
            [appObj.session openWithCompletionHandler:^(FBSession *session,
                                                        FBSessionState status,
                                                        NSError *error)
             {
                 [self updateView];
             }];
        }
        else
        {
            [self updateView];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"Network Not Connceted. Please Connect" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)updateView
{
    if (!appObj.session.isOpen)
    {
        return;
    }
    if (FBSession.activeSession.isOpen)
    {
        [self fbLogin];
    }
    else
    {
        [FBSession openActiveSessionWithReadPermissions:nil
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session,
                                                          FBSessionState status,
                                                          NSError *error)
         {
             if (error)
             {
                 UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                  message:error.localizedDescription
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
                 [alert1 show];
             }
             else
             {
                 [self fbLogin];
             }
         }];
    }
}

-(void)fbLogin
{
    [FBRequestConnection startWithGraphPath:@"/me"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection * connection, id result, NSError * error)
     {
         if (!error)
         {
             NSString * fbImagelink = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",[result valueForKey:@"id"]];
             
             NSLog(@"face book info is = %@\n %@ \n%@", fbImagelink ,[result valueForKey:@"name"],[result valueForKey:@"email"]);
             
             facebookID=[result valueForKey:@"id"];
             name=[result valueForKey:@"name"];
             place=[result valueForKey:@"place"];
             email=[result valueForKey:@"email"];
             faceBookLink = [result valueForKey:@"link"];
             fbEmailID = [result valueForKey:@"email"];
             
             [[NSNotificationCenter defaultCenter]postNotificationName:@"removeConnectNowBtn" object:nil];

             [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"ConnectLater"];
             [[NSUserDefaults standardUserDefaults]setValue:name forKey:@"fb_name"];
             [[NSUserDefaults standardUserDefaults]setValue:facebookID forKey:@"fb_id"];
             [[NSUserDefaults standardUserDefaults]setValue:faceBookLink forKey:@"fb_link"];
             [[NSUserDefaults standardUserDefaults]setValue:fbEmailID forKey:@"fb_email"];
             [[NSUserDefaults standardUserDefaults]setValue:fbImagelink forKey:@"fb_image"];
             
             [[NSUserDefaults standardUserDefaults]synchronize];
             
             [self dismissViewControllerAnimated:YES completion:nil];
         }
     }];
}

-(UIViewController *)returnViewcontrollerWithIdentifier:(NSString*)identifierName
{
    UIViewController * viewControllerObj = [[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:identifierName]];
    
    return viewControllerObj;
}

- (IBAction)loginwithTwitter:(id)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        self.accountStore = [[ACAccountStore alloc] init];
        
        ACAccountType *twitterAcc = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        [self.accountStore requestAccessToAccountsWithType:twitterAcc options:nil completion:^(BOOL granted, NSError *error)
         {
             if (granted)
             {
                 self.twitterAccount = [[self.accountStore accountsWithAccountType:twitterAcc] lastObject];
                 NSLog(@" name %@",self.twitterAccount.username);
                 
                 [[NSNotificationCenter defaultCenter]postNotificationName:@"removeConnectNowBtn" object:nil];

                 [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"ConnectLater"];
                 [[NSUserDefaults standardUserDefaults]setValue:@"twitterLogin" forKey:@"Twitter"];
                 [[NSUserDefaults standardUserDefaults]setValue:self.twitterAccount.username forKey:@"TwitterName"];
                 [[NSUserDefaults standardUserDefaults]synchronize];

                 [self dismissViewControllerAnimated:YES completion:nil];
             }
             else
             {
                 if (error == nil) {   
                     NSLog(@"User Has disabled your app from settings...");
                 }
                 else
                 {
                     NSLog(@"Error in Login: %@", error);
                 }
             }
         }];
    }
    else
    {
        UIAlertView *twitterAler = [[UIAlertView alloc]initWithTitle:@"Sorry!" message:@"Twitter was not configured in settings. Please Configure it." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [twitterAler show];
    }
}

- (IBAction)connectLater:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setValue:@"connectlater" forKey:@"ConnectLater"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
