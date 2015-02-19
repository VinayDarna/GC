//
//  PopOverViewController.h
//  GatewayConference
//
//  Created by Olive Tech on 10/02/15.
//  Copyright (c) 2015 Teja Swaroop. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SpeakersViewController.h"

@protocol PopOverDelegate <NSObject>

-(void)didSelectRow:(int)row ForValue:(NSString *)value ofType:(NSString *)type;

@end

@interface PopOverViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imagView;
@property (strong, nonatomic) IBOutlet UILabel *nameLbl;

@property (nonatomic,strong) id <PopOverDelegate> delegate;
@property (nonatomic, strong) GCModel *sponsorModelObj;

@end
