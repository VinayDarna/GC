//
//  VideosViewController.h
//  GatewayConference
//
//  Created by Olive Tech on 19/02/15.
//  Copyright (c) 2015 Teja Swaroop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideosViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *videosTable;
@property(nonatomic ,strong)NSMutableArray * videosArray;

-(void)getVideosDetails;

@end
