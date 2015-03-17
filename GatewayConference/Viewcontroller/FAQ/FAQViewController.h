//
//  FAQViewController.h
//  GatewayConference
//
//  Created by Olive Tech on 19/02/15.
//  Copyright (c) 2015 Teja Swaroop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FAQViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *faqTableView;
@property (nonatomic, retain) NSMutableArray *mainFaqArray;;

-(void)getFAQDetails;

@end
