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

@interface SponsorsViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, WYPopoverControllerDelegate>
{
    __weak IBOutlet UICollectionView *collectionView1;
    NSMutableArray *sponsorArray;
    UILabel *titleLabel;
    
    WYPopoverController * anotherPopoverController;
    WYPopoverController * settingsPopoverController;
}

@property (nonatomic, strong) UIPopoverController *erpDataPopover;

@end
