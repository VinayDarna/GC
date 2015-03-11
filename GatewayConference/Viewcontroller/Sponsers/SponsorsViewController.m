//
//  SponsorsViewController.m
//  GatewayConference
//
//  Created by Olive Tech on 20/01/15.
//  Copyright (c) 2015 Teja Swaroop. All rights reserved.
//

#import "SponsorsViewController.h"

#import "SponserCell.h"

#import "PopOverViewController.h"

@interface SponsorsViewController ()

@end

@implementation SponsorsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Application_BG"]];
//    [tempImageView setFrame:collectionView1.frame];
//    collectionView1.backgroundView = tempImageView;
   // collectionView1.backgroundColor = [UIColor colorWithRed:94.0/255.0 green:63.0/255.0 blue:67.0/255.0 alpha:1.0];
    
    sponsersTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height-65)];
    sponsersTableView.backgroundColor = [UIColor colorWithRed:95/255.0 green:63/255.0 blue:67/255.0 alpha:1.0];

    sponsersTableView.delegate = self;
    sponsersTableView.dataSource = self;
    sponsersTableView.separatorStyle = NO;
    
    [self.view addSubview:sponsersTableView];
   
    
    if ([[GCSharedClass sharedInstance]checkNetworkAndProceed:self])
    {
        [self getSponsorDetails];
    }else
    {
        NSLog(@"Error");
    }

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    }

-(void)getSponsorDetails
{
    [[GCSharedClass sharedInstance] showGlobalProgressHUDWithTitle:@"Loading..."];
    
    [[GCSharedClass sharedInstance] fetchDetailsWithParameter:url_Sponsors andReturnWith:^(NSMutableArray *speakers, BOOL Success) {
        if (Success)
        {
            [[GCSharedClass sharedInstance]dismissGlobalHUD];
            sponsorArray = [speakers copy];
            [sponsersTableView reloadData];
        }
        else
        {
            [[GCSharedClass sharedInstance]isNetworkAvalible];
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
    return [sponsorArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GCModel * gcSpeak = [sponsorArray objectAtIndex:indexPath.row];
    
    static NSString * simpleTableIdentifier = @"SponserCell";
    
    SponserCell * cell = (SponserCell *) [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SponserCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    [cell.sponser_image sd_setImageWithURL:[NSURL URLWithString:gcSpeak.logo]  placeholderImage:[UIImage imageNamed:@"Placeholder.jpeg"]];
    cell.sponser_image.layer.cornerRadius = cell.sponser_image.frame.size.width / 2;
    cell.sponser_image.clipsToBounds = YES;

    cell.bgView.layer.cornerRadius = 15;
    cell.bgView.layer.masksToBounds = YES;
    
    cell.sponser_title.text = gcSpeak.title;
  
    [cell.sponser_site addTarget:self action:@selector(ShowSelectedSite:) forControlEvents:UIControlEventTouchUpInside];
    cell.sponser_site.tag = indexPath.row;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(IBAction)ShowSelectedSite:(id)sender
{
    UIButton *buttonObj = (UIButton*)sender;
    
    NSLog(@"but %ld",(long)buttonObj.tag);
    
    GCModel * gcSpeak = [sponsorArray objectAtIndex:buttonObj.tag];
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:gcSpeak.url]];
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    SpeakerDetailsViewController * speDet = [story instantiateViewControllerWithIdentifier:@"SpeakerDetailsViewController"];
//    GCModel *modelObj = [sponsorArray objectAtIndex:indexPath.row];
//    speDet.speakerDetModelObj = modelObj;
//    [self.navigationController pushViewController:speDet animated:YES];
//}


/*
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return sponsorArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GCModel *model = [sponsorArray objectAtIndex:indexPath.row];
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    NSURL *url = [NSURL URLWithString:model.logo];
    [recipeImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Placeholder.jpeg"]];
    
    titleLabel = (UILabel *)[cell viewWithTag:10];
    titleLabel.text = model.title;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (settingsPopoverController == nil)
    {
        UICollectionViewCell * cell = [collectionView1 cellForItemAtIndexPath:indexPath];
        PopOverViewController * contro = [self.storyboard instantiateViewControllerWithIdentifier:@"PopOverViewController"];
        GCModel * modelObj = [sponsorArray objectAtIndex:indexPath.row];
        contro.sponsorModelObj = modelObj;
        
        contro.preferredContentSize = CGSizeMake(320, 400);
        contro.modalInPopover = NO;
        contro.delegate = (id)self;
        UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:contro];
        
        settingsPopoverController = [[WYPopoverController alloc]initWithContentViewController:contentViewController];
        [contro.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(close:)]];
        settingsPopoverController.delegate = (id)self;
        settingsPopoverController.passthroughViews = @[cell];
        settingsPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
        settingsPopoverController.wantsDefaultContentAppearance = YES;
        
        [settingsPopoverController presentPopoverAsDialogAnimated:YES
                                                          options:WYPopoverAnimationOptionFadeWithScale];
    }
    else
    {
        [self close:nil];
    }
}
*/

- (void)close:(id)sender
{
    [settingsPopoverController dismissPopoverAnimated:YES completion:^{
        [self popoverControllerDidDismissPopover:settingsPopoverController];
    }];
}

#pragma mark - WYPopoverControllerDelegate

- (void)popoverControllerDidPresentPopover:(WYPopoverController *)controller
{
    
}

- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller
{
    return NO;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller
{
    if (controller == anotherPopoverController)
    {
        anotherPopoverController.delegate = nil;
        anotherPopoverController = nil;
    }
    else if (controller == settingsPopoverController)
    {
        settingsPopoverController.delegate = nil;
        settingsPopoverController = nil;
    }
}

- (BOOL)popoverControllerShouldIgnoreKeyboardBounds:(WYPopoverController *)popoverController
{
    return YES;
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
