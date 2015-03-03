//
//  SponsorsViewController.h
//  GatewayConference
//
//  Created by Olive Tech on 20/01/15.
//  Copyright (c) 2015 Teja Swaroop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WYPopoverController.h>
#import <WYStoryboardPopoverSegue.h>

@interface SponsorsViewController : UIViewController <WYPopoverControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
   // __weak IBOutlet UICollectionView *collectionView1;
    NSMutableArray *sponsorArray;
    UILabel *titleLabel;
    
    WYPopoverController * anotherPopoverController;
    WYPopoverController * settingsPopoverController;
    
    
    UITableView *sponsersTableView;
}

@property (nonatomic, strong) UIPopoverController *erpDataPopover;

@end
