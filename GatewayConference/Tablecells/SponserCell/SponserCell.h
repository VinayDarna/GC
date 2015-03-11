//
//  SponserCell.h
//  GatewayConference
//
//  Created by Teja Swaroop on 26/02/15.
//  Copyright (c) 2015 Teja Swaroop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SponserCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UIImageView * sponser_image;
@property(nonatomic, strong) IBOutlet UILabel * sponser_title;
@property(nonatomic, strong) IBOutlet UIButton * sponser_site;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
