//
//  SpeakerDetailsViewController.h
//  GatewayConference
//
//  Created by Olive Tech on 14/01/15.
//  Copyright (c) 2015 Teja Swaroop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface SpeakerDetailsViewController : UIViewController
{
    __weak IBOutlet UILabel *nameLbl;
    __weak IBOutlet UIImageView *profilePic;
    __weak IBOutlet UILabel *churchLbl;
    __weak IBOutlet UITextView *detailText;
}

@property (nonatomic, strong) NSMutableArray * speakersDetailsArray;

@end
