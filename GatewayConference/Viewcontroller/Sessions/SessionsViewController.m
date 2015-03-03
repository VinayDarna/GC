//
//  FirstViewController.m
//  GatewayConference
//
//  Created by Olive Tech on 13/01/15.
//  Copyright (c) 2015 Teja Swaroop. All rights reserved.
//

#import "SessionsViewController.h"

@interface SessionsViewController ()

@end

@implementation SessionsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    schedulesTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height-65)];
    schedulesTable.backgroundColor = [UIColor colorWithRed:95/255.0 green:63/255.0 blue:67/255.0 alpha:1.0];
    
    schedulesTable.delegate = self;
    schedulesTable.dataSource = self;
    [self.view addSubview:schedulesTable];
    
    [self getScheduleDetails];
}

-(void)getScheduleDetails
{
    [[GCSharedClass sharedInstance]showGlobalProgressHUDWithTitle:@"Loading..."];
    
    [[GCSharedClass sharedInstance]fetchDetailsWithParameter:url_Schedules andReturnWith:^(NSMutableArray *schedulesArray, BOOL Success)
     {
         if (Success)
         {
             [[GCSharedClass sharedInstance] dismissGlobalHUD];
             
             NSLog(@"schedulesArray %@",schedulesArray);
             
             scheduleArray = [schedulesArray copy];
             
             [schedulesTable reloadData];
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
    return [scheduleArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GCModel * gcSpeak = [scheduleArray objectAtIndex:indexPath.row];
    
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        cell.textLabel.textColor = [UIColor whiteColor];
         cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = gcSpeak.title;
    cell.detailTextLabel.text = gcSpeak.datetime;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
