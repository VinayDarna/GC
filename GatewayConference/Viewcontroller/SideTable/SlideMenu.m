//
//  SlideViewController.m
//  GatewayConference
//
//  Created by Olive Tech on 13/01/15.
//  Copyright (c) 2015 Teja Swaroop. All rights reserved.
//

#import "SlideMenu.h"
#import "SessionsViewController.h"
#import "POIViewController.h"
#import "UIViewController+RESideMenu.h"

@interface SlideMenu ()

@property (strong, readwrite, nonatomic) UITableView *tableView;

@end

@implementation SlideMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   // [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"SideBackMenu.png"]]];
     
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 5) / 2.0f, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
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
  //  titles = [[NSArray alloc] initWithObjects:@"Speakers", @"Sessions", @"POI", @"Attendies List",@"Sponsors",@"Videos" ,@"Survey",@"FAQ", nil];
    
    titles = [[NSArray alloc] initWithObjects:@"Speakers",@"Sponsors",@"Videos" ,@"Survey",@"FAQ",@"Schedules", nil];

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
        [cell.textLabel setFont:[UIFont fontWithName: @"Heiti TC" size:(20.0f)]];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
    return cell;
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
            [self.sideMenuViewController setContentViewController:[self returnViewcontrollerWithIdentifier:@"FirstViewController"] animated:YES];
            break;
        case 1:
            [self.sideMenuViewController setContentViewController:[self returnViewcontrollerWithIdentifier:@"SponsorsViewController"] animated:YES];
            break;
        case 2:
            [self.sideMenuViewController setContentViewController:[self returnViewcontrollerWithIdentifier:@"VideosViewController"] animated:YES];
            break;
        case 3:
            [self.sideMenuViewController setContentViewController:[self returnViewcontrollerWithIdentifier:@"SurveyViewController"] animated:YES];
            break;
        case 4:
            [self.sideMenuViewController setContentViewController:[self returnViewcontrollerWithIdentifier:@"FAQViewController"] animated:YES];
            break;
        case 5:
            [self.sideMenuViewController setContentViewController:[self returnViewcontrollerWithIdentifier:@"SecondViewController"] animated:YES];
            break;
        default:
            break;
    }    
    [self.sideMenuViewController hideMenuViewController];
}

-(UIViewController*)returnViewcontrollerWithIdentifier:(NSString*)identifierName
{
    UIViewController * viewControllerObj = [[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:identifierName]];
    
    return viewControllerObj;
}

@end
