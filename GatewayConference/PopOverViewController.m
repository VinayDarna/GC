//
//  PopOverViewController.m
//  GatewayConference
//
//  Created by Olive Tech on 10/02/15.
//  Copyright (c) 2015 Teja Swaroop. All rights reserved.
//

#import "PopOverViewController.h"

#import "GCSpeakerModel.h"

@interface PopOverViewController ()

@end

@implementation PopOverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    _nameLbl.text = _nameString;
    NSURL *imageUrl = [NSURL URLWithString:_imageUrlString];
    [_imagView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"Placeholder.jpeg"]];
}

- (IBAction)visitWebPage:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_webUrlString]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
