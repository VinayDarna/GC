//
//  SponsorsViewController.m
//  GatewayConference
//
//  Created by Olive Tech on 20/01/15.
//  Copyright (c) 2015 Teja Swaroop. All rights reserved.
//

#import "SponsorsViewController.h"
#import "GCSpeakerModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "GCSharedClass.h"

@interface SponsorsViewController ()

@end

@implementation SponsorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Application_BG"]];
    [tempImageView setFrame:collectionView1.frame];
    collectionView1.backgroundView = tempImageView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [[GCSharedClass sharedInstance]fetchDetailsWithParameter:@"sponsors" andReturnWith:^(NSMutableArray *speakers, BOOL Success) {
        if (Success)
        {
            sponsorArray = [speakers copy];
            [collectionView1 reloadData];
        }
        else
        {
            UIAlertView *Alert = [[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Data can't be Fetched" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert show];
        }
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return sponsorArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GCSpeakerModel *model = [sponsorArray objectAtIndex:indexPath.row];
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
    NSLog(@"%ld",(long)indexPath.item);
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
