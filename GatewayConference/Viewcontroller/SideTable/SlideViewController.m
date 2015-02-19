//
//  SlideViewController.m
//  GatewayConference
//
//  Created by Olive Tech on 13/01/15.
//  Copyright (c) 2015 Teja Swaroop. All rights reserved.
//

#import "SlideViewController.h"
#import "SessionsViewController.h"
#import "POIViewController.h"
#import "UIViewController+RESideMenu.h"

@interface SlideViewController ()

@property (strong, readwrite, nonatomic) UITableView *tableView;

@end

@implementation SlideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 5) / 2.0f, self.view.frame.size.width, 500) style:UITableViewStylePlain];
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
    titles = [[NSArray alloc] initWithObjects:@"Speakers", @"Sessions", @"POI", @"Attendies List",@"Sponsors",@"Videos" ,@"Survey",@"FAQ", nil];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"FirstViewController"]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 1:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SecondViewController"]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 2: 
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"POIViewController"]] animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 3:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"AttendiesListViewController"]] animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 4:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SponsorsViewController"]] animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 5:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"VideosViewController"]] animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 6:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SurveyViewController"]] animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 7:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"FAQViewController"]] animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        default:
            break;
    }
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (indexPath.row == 0)
    //    {
    //        return 200;
    //    }
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
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
    
    //    if (indexPath.row == 0)
    //    {
    //        UIImageView*  imgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x+10, 0, 80 ,20)];
    //        imgView.image = [UIImage imageNamed:@"Hamburger"];
    //        [cell.contentView addSubview:imgView];
    //    }else
    
    {
        cell.textLabel.text = titles[indexPath.row];
        [cell.textLabel setFont:FONT_NEW_HEADING_BOLDwithFontSize(30.0)];
        cell.textLabel.textColor = RGBCOLOR(255, 255, 255);
    }
    
    return cell;
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
