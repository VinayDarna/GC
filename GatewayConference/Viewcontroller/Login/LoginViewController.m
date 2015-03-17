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
            appObj.session = [[FBSession alloc] initWithPermissions:[NSArray arrayWithObjects:@"user_events",@"rsvp_event",@"publish_stream",@"friends_events",nil]];
            
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
        NSLog(@"No internet");
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
             NSString * fbImagelink = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture",[result valueForKey:@"id"]];
             
             NSLog(@"face book info is = %@\n %@ \n%@", fbImagelink ,[result valueForKey:@"name"],[result valueForKey:@"email"]);
             
             facebookID=[result valueForKey:@"id"];
             name=[result valueForKey:@"name"];
             place=[result valueForKey:@"place"];
             email=[result valueForKey:@"email"];
             faceBookLink = [result valueForKey:@"link"];
             
             [[NSNotificationCenter defaultCenter]postNotificationName:@"remove" object:nil];
             
             [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"ConnectLater"];
             
             [[NSUserDefaults standardUserDefaults]setValue:name forKey:@"fb_name"];
             [[NSUserDefaults standardUserDefaults]setValue:facebookID forKey:@"fb_id"];
             [[NSUserDefaults standardUserDefaults]setValue:faceBookLink forKey:@"fb_link"];
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

- (IBAction)loginwithTwitter:(id)sender {
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
