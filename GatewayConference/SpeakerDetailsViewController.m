//
//  SpeakerDetailsViewController.m
//  GatewayConference
//
//  Created by Olive Tech on 14/01/15.
//  Copyright (c) 2015 Teja Swaroop. All rights reserved.
//

#import "SpeakerDetailsViewController.h"
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
    NSLog(@"%@",_speakersDetailsArray);
    
    nameLbl.text = [_speakersDetailsArray valueForKey:@"title"];
    churchLbl.text = [_speakersDetailsArray valueForKey:@"organization"];
    detailText.text = [_speakersDetailsArray valueForKey:@"body"];
    
    UIImage *placeHolderImage = [UIImage imageNamed:@"Placeholder.jpeg"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[_speakersDetailsArray valueForKey:@"image"]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [profilePic setImageWithURLRequest:request
                      placeholderImage:placeHolderImage
                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                   [profilePic setImage:image];
                               } failure:nil];
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
