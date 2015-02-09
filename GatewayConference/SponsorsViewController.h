//
//  SponsorsViewController.h
//  GatewayConference
//
//  Created by Olive Tech on 20/01/15.
//  Copyright (c) 2015 Teja Swaroop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SponsorsViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
{
    __weak IBOutlet UICollectionView *collectionView1;
    NSMutableArray *sponsorArray;
    UILabel *titleLabel;
}
@end
