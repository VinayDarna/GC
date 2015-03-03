//
//  FAQViewController.m
//  GatewayConference
//
//  Created by Olive Tech on 19/02/15.
//  Copyright (c) 2015 Teja Swaroop. All rights reserved.
//

#import "FAQViewController.h"

#import "FAQTableViewCell.h"

#import "GCModel.h"

@interface FAQViewController ()

@end

@implementation FAQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    if ([[GCSharedClass sharedInstance]checkNetworkAndProceed:self])
    {
        [self getFAQDetails];
    }
    else
    {
        NSLog(@"Error in fetching");
    }

}

-(void)getFAQDetails
{
    [[GCSharedClass sharedInstance]showGlobalProgressHUDWithTitle:@"Loading..."];
    
    [[GCSharedClass sharedInstance]fetchDetailsWithParameter:url_Faq andReturnWith:^(NSMutableArray *faqArray, BOOL Success)
     {
         if (Success)
         {
             [[GCSharedClass sharedInstance] dismissGlobalHUD];
             
             NSLog(@"FAQ %@",faqArray);
             _mainFaqArray = [faqArray copy];
             [_faqTableView reloadData];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_mainFaqArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 290;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GCModel *model = [_mainFaqArray objectAtIndex:indexPath.row];
    
    static NSString * simpleTableIdentifier = @"FaqCell";
    
    FAQTableViewCell *cell = (FAQTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FAQTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.faqView.layer.cornerRadius = 15;
    cell.faqView.layer.masksToBounds = YES;
    
    cell.questionLabel.text = model.title;
    cell.answerLabel.text = model.body;
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
