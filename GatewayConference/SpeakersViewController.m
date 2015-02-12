//
//  SpeakersViewController.m
//  GatewayConference
//
//  Created by Olive Tech on 14/01/15.
//  Copyright (c) 2015 Teja Swaroop. All rights reserved.
//

#import "SpeakersViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>

#import "GCSpeakerModel.h"

#import "MainViewCell.h"

@interface SpeakersViewController ()

@end

@implementation SpeakersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([[GCSharedClass sharedInstance]checkNetworkAndProceed:self])
    {
        [self getSpeakerDetails];
    }
    else{
        NSLog(@"Error in fetching");
    }
    [[GCSharedClass sharedInstance]fetchParseDetails];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Application_BG"]]];
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"App-BG"]];
    [tempImageView setFrame:speakersTableView.frame];
    speakersTableView.backgroundView = tempImageView;
}

-(void)getSpeakerDetails
{
    [[GCSharedClass sharedInstance]showGlobalProgressHUDWithTitle:@"Loading..."];
    
    [[GCSharedClass sharedInstance]fetchDetailsWithParameter:@"speakers" andReturnWith:^(NSMutableArray *speakers, BOOL Success)
     {
         if (Success)
         {
             [[GCSharedClass sharedInstance] dismissGlobalHUD];
             speakersArray = [speakers copy];
             [speakersTableView reloadData];
         }
         else
         {
             UIAlertView *Alert = [[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Data can't be Fetched" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [Alert show];
             [[GCSharedClass sharedInstance] dismissGlobalHUD];
         }
     }];
}

#pragma UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [speakersArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GCSpeakerModel * gcSpeak = [speakersArray objectAtIndex:indexPath.row];
    static NSString * simpleTableIdentifier = @"SpeakerCell";
    
    MainViewCell * cell = (MainViewCell *) [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MainViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    NSURL *url = [NSURL URLWithString:gcSpeak.image];
    [cell.profilePic sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Placeholder.jpeg"]];
    cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width / 2;
    cell.profilePic.clipsToBounds = YES;
    
    cell.nameLbl.text = gcSpeak.title;
    cell.churchLbl.text = gcSpeak.organization;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SpeakerDetailsViewController * speDet = [story instantiateViewControllerWithIdentifier:@"SpeakerDetailsViewController"];
    GCSpeakerModel *modelObj = [speakersArray objectAtIndex:indexPath.row];
    speDet.speakerDetModelObj = modelObj;
    [self.navigationController pushViewController:speDet animated:YES];
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
