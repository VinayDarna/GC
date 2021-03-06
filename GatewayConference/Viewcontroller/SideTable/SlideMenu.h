//
//  SlideViewController.h
//  GatewayConference
//
//  Created by Olive Tech on 13/01/15.
//  Copyright (c) 2015 Teja Swaroop. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RESideMenu.h"

@interface SlideMenu : UIViewController <UITableViewDataSource, UITableViewDelegate, RESideMenuDelegate>
{
    NSArray *titles;
    NSArray *imagesArray;
    UIButton *button;
}

-(UIViewController*)returnViewcontrollerWithIdentifier:(NSString*)identifierName;

@end
