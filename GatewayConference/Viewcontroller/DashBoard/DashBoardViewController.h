//
//  DashBoardViewController.h
//  GatewayConference
//
//  Created by Olive Tech on 04/03/15.
//  Copyright (c) 2015 Teja Swaroop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashBoardViewController : UIViewController
{
    AppDelegate *appObj;
    int noIs;
}
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@end
