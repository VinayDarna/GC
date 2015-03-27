//
//  SlideViewController.m
//  GatewayConference
//
//  Created by Olive Tech on 13/01/15.
//  Copyright (c) 2015 Teja Swaroop. All rights reserved.
//

#import "SlideMenu.h"

#import "UIViewController+RESideMenu.h"

#import "LoginViewController.h"

@interface SlideMenu ()

@property (strong, readwrite, nonatomic) UITableView *tableView;

@end

@implementation SlideMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 125, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView.scrollsToTop = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
    
    titles = [[NSArray alloc] initWithObjects:@"DashBoard",@"Speakers",@"Sponsors",@"Videos" ,@"Survey",@"FAQ",@"Schedules",@"PointsOfInterest",@"#Tag",@"RealEyes", nil];
    
    imagesArray = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"SidebarImages1@2x.png"],[UIImage imageNamed:@"SidebarImages2@2x.png"],[UIImage imageNamed:@"SidebarImages3@2x.png"],[UIImage imageNamed:@"SidebarImages4@2x.png"],[UIImage imageNamed:@"SidebarImages1@2x.png"],[UIImage imageNamed:@"SidebarImages2@2x.png"],[UIImage imageNamed:@"SidebarImages3@2x.png"],[UIImage imageNamed:@"SidebarImages1@2x.png"],[UIImage imageNamed:@"SidebarImages2@2x.png"],[UIImage imageNamed:@"SidebarImages3@2x.png"], nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeCoonectNowBtn) name:@"removeConnectNowBtn" object:nil];
}

-(void)removeCoonectNowBtn
{
    [button setHidden:YES];
     [button removeFromSuperview];
     [self.sideMenuViewController hideMenuViewController];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 50;
    }
    return 45;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if (sectionIndex==0)
    {
        return 1;
    }
    return titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    if (indexPath.section == 0)
    {
        button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self action:@selector(connectNowClk)
         forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"Connect Now" forState:UIControlStateNormal];
        button.frame = CGRectMake(self.view.frame.origin.x+50, 0, 150 ,50);
        button.titleLabel.font = [UIFont fontWithName: @"Helvetica Bold" size:(20.0f)];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"fb_id"]length]> 0)
        {
            [button removeFromSuperview];
        }
        else
        {
            [cell.contentView addSubview:button];
        }
    }
    else
    {
        cell.textLabel.text = titles[indexPath.row];
        [cell.textLabel setFont:[UIFont fontWithName: @"Heiti TC" size:(20.0f)]];
        cell.textLabel.textColor = [UIColor whiteColor];
        
        cell.imageView.image = imagesArray[indexPath.row];
        
    }
    return cell;
}

-(void)connectNowClk
{
    LoginViewController *loginObj = (LoginViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self presentViewController:loginObj animated:YES completion:^{
        NSLog(@"Presented");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row)
    {
        case 0:
            [self.sideMenuViewController setContentViewController:[self returnViewcontrollerWithIdentifier:@"DashBoardViewController"] animated:YES];
            break;
        case 1:
            [self.sideMenuViewController setContentViewController:[self returnViewcontrollerWithIdentifier:@"SpeakersViewController"] animated:YES];
            break;
        case 2:
            [self.sideMenuViewController setContentViewController:[self returnViewcontrollerWithIdentifier:@"SponsorsViewController"] animated:YES];
            break;
        case 3:
            [self.sideMenuViewController setContentViewController:[self returnViewcontrollerWithIdentifier:@"VideosViewController"] animated:YES];
            break;
        case 4:
            [self.sideMenuViewController setContentViewController:[self returnViewcontrollerWithIdentifier:@"SurveyViewController"] animated:YES];
            break;
        case 5:
            [self.sideMenuViewController setContentViewController:[self returnViewcontrollerWithIdentifier:@"FAQViewController"] animated:YES];
            break;
        case 6:
            [self.sideMenuViewController setContentViewController:[self returnViewcontrollerWithIdentifier:@"SessionsViewController"] animated:YES];
            break;
        case 7:
            [self.sideMenuViewController setContentViewController:[self returnViewcontrollerWithIdentifier:@"POIViewController"] animated:YES];
            break;
        case 8:
            [self.sideMenuViewController setContentViewController:[self returnViewcontrollerWithIdentifier:@"HashTagViewController"] animated:YES];
            break;
        case 9:
            [self.sideMenuViewController setContentViewController:[self returnViewcontrollerWithIdentifier:@"RealEyesViewController"] animated:YES];
            break;
        default:
            break;
    }
    [self.sideMenuViewController hideMenuViewController];
}

-(UIViewController *)returnViewcontrollerWithIdentifier:(NSString*)identifierName
{
    UIViewController * viewControllerObj = [[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:identifierName]];
    
    return viewControllerObj;
}

@end
