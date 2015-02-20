//
//  VideosViewController.m
//  GatewayConference
//
//  Created by Olive Tech on 19/02/15.
//  Copyright (c) 2015 Teja Swaroop. All rights reserved.
//

#import "VideosViewController.h"

#import "VideosCellTableViewCell.h"

#import "VideoplayerViewController.h"

@interface VideosViewController ()

@end

@implementation VideosViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.videosTable.backgroundColor = [UIColor colorWithRed:70.0/255.0 green:24.0/255.0 blue:8.0/255.0 alpha:1.0];
    
    /**
     * To get the Videos Details
     */
    
     [self getVideosDetails];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)getVideosDetails
{
    self.videosArray = [NSMutableArray new];
    
    [[GCSharedClass sharedInstance]showGlobalProgressHUDWithTitle:@"Loading..."];
    
    [[GCSharedClass sharedInstance]fetchDetailsWithParameter:url_Videos andReturnWith:^(NSMutableArray *videosArray, BOOL Success)
     {
         if (Success)
         {
             [[GCSharedClass sharedInstance] dismissGlobalHUD];

             self.videosArray = [videosArray copy];
             
             [self.videosTable reloadData];
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
    return [self.videosArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GCModel * gcObject = [self.videosArray objectAtIndex:indexPath.row];
    
    static NSString * simpleTableIdentifier = @"VideoCell";
    
    VideosCellTableViewCell * cell = (VideosCellTableViewCell *) [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"VideosCellTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.title.text = gcObject.title;
    cell.category.text = gcObject.categorization;
    
    [cell.imageObj sd_setImageWithURL:[NSURL URLWithString:gcObject.image] placeholderImage:[UIImage imageNamed:@"Placeholder.jpeg"]];
    cell.imageObj.layer.cornerRadius = cell.imageObj.frame.size.width / 2;
    cell.imageObj.clipsToBounds = YES;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GCModel * gcObject = [self.videosArray objectAtIndex:indexPath.row];
    
    NSLog(@"play videos %@",gcObject.url);
    
    VideoplayerViewController * playerObj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"VideoplayerViewController"];

    playerObj.modelObj = gcObject;
    [self.navigationController pushViewController:playerObj animated:YES];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
