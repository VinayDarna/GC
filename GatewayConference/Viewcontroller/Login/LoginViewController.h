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
#import "STTwitter.h"


typedef void (^accountChooserBlock_t)(ACAccount *account, NSString *errorMessage);

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
    NSString * fbEmailID;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *connectWithFB;
@property (weak, nonatomic) IBOutlet UIButton *connectWithTwitter;
@property (weak, nonatomic) IBOutlet UIButton *connectLater;

@property (nonatomic, retain) ACAccountStore * accountStore;
@property (nonatomic, strong) ACAccount * twitterAccount;


@property (nonatomic, strong) NSString * twiusername;
//@property (nonatomic, strong) NSString * userFullName;
@property (nonatomic, strong) accountChooserBlock_t accountChooserBlock;
@property (nonatomic, weak) IBOutlet UILabel *loginStatusLabel;
@property (nonatomic, strong) STTwitterAPI *STtwitter;
@property (nonatomic, strong) NSArray *iOSAccounts;





@end
