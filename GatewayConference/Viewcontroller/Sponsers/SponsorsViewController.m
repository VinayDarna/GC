//
//  SponsorsViewController.m
//  GatewayConference
//
//  Created by Olive Tech on 20/01/15.
//  Copyright (c) 2015 Teja Swaroop. All rights reserved.
//

#import "SponsorsViewController.h"

#import "PopOverViewController.h"

@interface SponsorsViewController ()

@end

@implementation SponsorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Application_BG"]];
//    [tempImageView setFrame:collectionView1.frame];
//    collectionView1.backgroundView = tempImageView;
    collectionView1.backgroundColor = [UIColor colorWithRed:70.0/255.0 green:34.0/255.0 blue:8.0/255.0 alpha:1.0];
}

-(void)viewWillAppear:(BOOL)animated
{
    if ([[GCSharedClass sharedInstance]checkNetworkAndProceed:self])
    {
        [self getSponsorDetails];
    }else
    {
        NSLog(@"Error");
    }
}

-(void)getSponsorDetails
{
    [[GCSharedClass sharedInstance] showGlobalProgressHUDWithTitle:@"Loading..."];
    
    [[GCSharedClass sharedInstance] fetchDetailsWithParameter:url_Sponsors andReturnWith:^(NSMutableArray *speakers, BOOL Success) {
        if (Success)
        {
            [[GCSharedClass sharedInstance]dismissGlobalHUD];
            sponsorArray = [speakers copy];
            [collectionView1 reloadData];
        }
        else
        {
            [[GCSharedClass sharedInstance]isNetworkAvalible];
        }
    }];
}

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
