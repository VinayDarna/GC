//
//  FirstViewController.m
//  GatewayConference
//
//  Created by Olive Tech on 13/01/15.
//  Copyright (c) 2015 Teja Swaroop. All rights reserved.
//

#import "SessionsViewController.h"
static NSString *const cellIndentifier = @"TableViewCell";

@interface SessionsViewController ()

@property (nonatomic,strong) NSArray *tableContents;
@property (nonatomic,strong) NSMutableArray *filteredContents;

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
    
    [schedulesTable registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIndentifier];
}

-(void)getScheduleDetails
{
    [[GCSharedClass sharedInstance]showGlobalProgressHUDWithTitle:@"Loading..."];
    
    [[GCSharedClass sharedInstance]fetchDetailsWithParameter:url_Schedules andReturnWith:^(NSMutableArray *schedulesArray, BOOL Success)
     {
         if (Success)
         {
             [[GCSharedClass sharedInstance] dismissGlobalHUD];
             
             // NSLog(@"schedulesArray %@",schedulesArray);
             
             NSArray * commanDatesArray = [[NSSet setWithArray:[schedulesArray valueForKey:@"sessionDay"]] allObjects];
             
             NSMutableArray * dataArray = [NSMutableArray new];
             
             for (int i = 0; i < [commanDatesArray count]; i++)
             {
                 [dataArray addObject:[schedulesArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K == %@",@"sessionDay", [commanDatesArray objectAtIndex:i]]]];
             }
             
             NSLog(@"commandataArray %@",dataArray);
             scheduleArray = [dataArray mutableCopy];
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
    GCModel *model;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
    
    if(!cell )
    {
        cell = [ [ UITableViewCell alloc ] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: cellIndentifier ];
    }
    else
    {
        NSArray * tesmpArray = [scheduleArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [[tesmpArray objectAtIndex:0]valueForKey:@"sessionDay"];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        [cell setBackgroundColor:[UIColor clearColor]];
        if ( tesmpArray .count > 1)
        {
             model.isExpandable = YES;
             cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else{
            model.isExpandable = NO;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if([[scheduleArray objectAtIndex:indexPath.row]isExpandable])
//    {
//        if(![[self.filteredContents objectAtIndex:indexPath.row]expanded])
//        {
//            [schedulesTable insertRowsAtIndexPaths:[GCModel addChildrenFromArray:scheduleArray to:self.filteredContents atIndex:indexPath.row] withRowAnimation:UITableViewRowAnimationTop];
//        }
//        else
//            
//        {
//            [schedulesTable deleteRowsAtIndexPaths:[GCModel removeChildrenUsingArray:self.tableContents to:self.filteredContents atIndex:indexPath.row] withRowAnimation:UITableViewRowAnimationTop];
//        }
//    }
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Have to do functionality." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

//- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if([[self.filteredContents objectAtIndex:indexPath.row]parent] == nil)
//    {
//        return 0;
//    }
//    else
//    {
//        return 2;
//    }
//}

-(NSArray *)tableContents
{
    if(!_tableContents)
    {
        _tableContents = [GCModel defaultTableContents];
    }
    return _tableContents;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
