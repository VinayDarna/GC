//
//  SpeakerDetailsViewController.m
//  GatewayConference
//
//  Created by Olive Tech on 14/01/15.
//  Copyright (c) 2015 Teja Swaroop. All rights reserved.
//

#import "SpeakerDetailsViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>

#import "UIImageView+AFNetworking.h"

@interface SpeakerDetailsViewController ()

@end

@implementation SpeakerDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)viewWillAppear:(BOOL)animated
{
    if ([[GCSharedClass sharedInstance]checkNetworkAndProceed:self])
    {
        [[GCSharedClass sharedInstance]showGlobalProgressHUDWithTitle:@"Loading..."];
        [self speakerDetails];
    }
    else
    {
        
    }
}

-(void)speakerDetails
{
    nameLbl.text = _speakerDetModelObj.title;
    churchLbl.text = _speakerDetModelObj.organization;
    detailText.text = _speakerDetModelObj.body;
    
    UIImage *placeHolderImage = [UIImage imageNamed:@"Placeholder.jpeg"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",_speakerDetModelObj.image_banner]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [profilePic setImageWithURLRequest:request
                      placeholderImage:placeHolderImage
                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                                   [profilePic setImage:image];
                                   [[GCSharedClass sharedInstance] dismissGlobalHUD];
                               } failure:nil];
    [self labelAnimation];
}

-(void)labelAnimation
{
    [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{
        nameLbl.frame = CGRectMake(-self.view.frame.size.width, nameLbl.frame.size.height, nameLbl.frame.size.width, nameLbl.frame.size.height);
        churchLbl.frame = CGRectMake(self.view.frame.size.width, churchLbl.frame.size.height, churchLbl.frame.size.width, churchLbl.frame.size.height);
    } completion:^(BOOL finished)
     {
         
     }];
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
