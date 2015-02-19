//
//  SpeakersViewController.m
//  GatewayConference
//
//  Created by Olive Tech on 14/01/15.
//  Copyright (c) 2015 Teja Swaroop. All rights reserved.
//

#import "SpeakersViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>

#import "GCModel.h"

#import "MainViewCell.h"

@interface SpeakersViewController ()

@end

@implementation SpeakersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([[GCSharedClass sharedInstance]checkNetworkAndProceed:self])
    {
        /**
         * Unhide to get the Speker Details
         */
        //[self getSpeakerDetails];
        
        /**
         * Unhide to get the Tracks Details
         */
       // [self getTracksDetails];
        
        
        /**
         * Unhide to get the Places Details
         */
       // [self getPlacesDetails];
        
        
        [self getScheduleDetails];
        
    }
    else
    {
        NSLog(@"Error in fetching");
    }
    
    [[GCSharedClass sharedInstance]fetchParseDetails];
}

-(void)getScheduleDetails
{
    [[GCSharedClass sharedInstance]showGlobalProgressHUDWithTitle:@"Loading..."];
    
    [[GCSharedClass sharedInstance]fetchDetailsWithParameter:url_Schedules andReturnWith:^(NSMutableArray *schedulesArray, BOOL Success)
     {
         if (Success)
         {
             [[GCSharedClass sharedInstance] dismissGlobalHUD];
             
             NSLog(@"tracksArray %@",schedulesArray);
             
         }
         else
         {
             UIAlertView *Alert = [[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Data can't be Fetched" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [Alert show];
             [[GCSharedClass sharedInstance] dismissGlobalHUD];
         }
     }];
    
}


-(void)getPlacesDetails
{
    [[GCSharedClass sharedInstance]showGlobalProgressHUDWithTitle:@"Loading..."];
    
    [[GCSharedClass sharedInstance]fetchDetailsWithParameter:url_Places andReturnWith:^(NSMutableArray *placesArray, BOOL Success)
     {
         if (Success)
         {
             [[GCSharedClass sharedInstance] dismissGlobalHUD];
             
             NSLog(@"tracksArray %@",placesArray);
             
         }
         else
         {
             UIAlertView *Alert = [[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Data can't be Fetched" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [Alert show];
             [[GCSharedClass sharedInstance] dismissGlobalHUD];
         }
     }];
    
}

-(void)getTracksDetails
{
    [[GCSharedClass sharedInstance]showGlobalProgressHUDWithTitle:@"Loading..."];
    
    [[GCSharedClass sharedInstance]fetchDetailsWithParameter:url_Tracks andReturnWith:^(NSMutableArray *tracksArray, BOOL Success)
     {
         if (Success)
         {
             [[GCSharedClass sharedInstance] dismissGlobalHUD];
           
             NSLog(@"tracksArray %@",tracksArray);
             
         }
         else
         {
             UIAlertView *Alert = [[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Data can't be Fetched" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [Alert show];
             [[GCSharedClass sharedInstance] dismissGlobalHUD];
         }
     }];

}

-(void)viewWillAppear:(BOOL)animated
{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Application_BG"]]];
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.png"]];
    [tempImageView setFrame:speakersTableView.frame];
    speakersTableView.backgroundView = tempImageView;
}

-(void)getSpeakerDetails
{
    [[GCSharedClass sharedInstance]showGlobalProgressHUDWithTitle:@"Loading..."];
    
    [[GCSharedClass sharedInstance]fetchDetailsWithParameter:url_Speakers andReturnWith:^(NSMutableArray *speakers, BOOL Success)
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
    return 140.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GCModel * gcSpeak = [speakersArray objectAtIndex:indexPath.row];
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
    
    cell.bgView.layer.cornerRadius = 15;
    cell.bgView.layer.masksToBounds = YES;
    
    cell.nameLbl.text = gcSpeak.title;
    cell.churchLbl.text = gcSpeak.organization;
    cell.speakerTypeLbl.text = gcSpeak.location;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SpeakerDetailsViewController * speDet = [story instantiateViewControllerWithIdentifier:@"SpeakerDetailsViewController"];
    GCModel *modelObj = [speakersArray objectAtIndex:indexPath.row];
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
