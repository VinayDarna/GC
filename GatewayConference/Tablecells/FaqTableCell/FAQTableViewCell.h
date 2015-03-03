//
//  FAQTableViewCell.h
//  GatewayConference
//
//  Created by Olive Tech on 19/02/15.
//  Copyright (c) 2015 Teja Swaroop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FAQTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView * faqView;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;

@end
