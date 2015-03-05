//
//  FirstViewController.h
//  GatewayConference
//
//  Created by Olive Tech on 13/01/15.
//  Copyright (c) 2015 Teja Swaroop. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RESideMenu.h"

@interface SessionsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *schedulesTable;
    NSMutableArray *scheduleArray;
}

@end
