//
//  VideosViewController.m
//  GatewayConference
//
//  Created by Olive Tech on 19/02/15.
//  Copyright (c) 2015 Teja Swaroop. All rights reserved.
//

#import "VideosViewController.h"

#import "VideosCellTableViewCell.h"

@interface VideosViewController ()

@end

@implementation VideosViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self createTableView];
    
    /**
     * To get the Videos Details
     */
    
     [self getVideosDetails];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)createTableView
{
    self.videosTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height)];
    self.videosTable .autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    self.videosTable .delegate = self;
    self.videosTable .dataSource = self;
    
    [self.view addSubview:self.videosTable ];
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
    
    VideosCellTableViewCell * cell = nil;
    
    cell = (VideosCellTableViewCell *) [tableView dequeueReusableCellWithIdentifier:nil];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"VideosCellTableViewCell" owner:self options:nil];
    
    cell = [nib objectAtIndex:0];
//    if (cell == nil)
//    {
//       
//    }
//    
     cell.title.text = gcObject.title;
     cell.category.text = gcObject.categorization;
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:gcObject.image] placeholderImage:[UIImage imageNamed:@"Placeholder.jpeg"]];
    cell.imageObj.layer.cornerRadius = cell.imageObj.frame.size.width / 2;
    cell.imageObj.clipsToBounds = YES;
    
    cell.imageObj.layer.cornerRadius = 15;
    cell.imageObj.layer.masksToBounds = YES;
    [cell.backgroundView setBackgroundColor:[UIColor clearColor]];

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
