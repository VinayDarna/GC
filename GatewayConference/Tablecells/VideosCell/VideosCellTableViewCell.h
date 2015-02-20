//
//  VideosCellTableViewCell.h
//  GatewayConference
//
//  Created by Teja Swaroop on 20/02/15.
//  Copyright (c) 2015 Teja Swaroop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideosCellTableViewCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UILabel * title;
@property(nonatomic, strong) IBOutlet UILabel * category;
@property(nonatomic, strong) IBOutlet UIImageView * imageObj;

@end
