//
//  SpeakersViewController.h
//  GatewayConference
//
//  Created by Olive Tech on 14/01/15.
//  Copyright (c) 2015 Teja Swaroop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpeakerDetailsViewController.h"

@interface SpeakersViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    __weak IBOutlet UITableView *speakersTableView;
    NSMutableArray *speakersArray;
}



@end
