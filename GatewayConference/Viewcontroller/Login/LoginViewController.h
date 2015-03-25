//
//  LoginViewController.h
//  GatewayConference
//
//  Created by Olive Tech on 05/03/15.
//  Copyright (c) 2015 Teja Swaroop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "DashBoardViewController.h"
#import "SessionsViewController.h"


@class HomeViewController;

@interface LoginViewController : UIViewController
{
    AppDelegate *appObj;
    HomeViewController * home;
    DashBoardViewController *dash;
    
    NSString * facebookID;
    NSString * name;
    NSString * place;
    NSString * email;
    NSString * faceBookLink;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *connectWithFB;
@property (weak, nonatomic) IBOutlet UIButton *connectWithTwitter;
@property (weak, nonatomic) IBOutlet UIButton *connectLater;

@property (nonatomic, retain) ACAccountStore * accountStore;
@property (nonatomic, strong) ACAccount * twitterAccount;

//@property (nonatomic, strong) NSString * username;
//@property (nonatomic, strong) NSString * userFullName;

@end
